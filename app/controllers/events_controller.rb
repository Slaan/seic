class EventsController < ApplicationController

  before_action :logged_in_user
  before_action :set_event, only: [:show, :edit, :join, :leave, :update]

  CONNECTOR = ConnectorFactory.connection

  def new
    @event = Event.new
    get_tracks
    if params[:group_id]
      # check if group_id is valid to prevent method from writing invalid ids to new events
      @event.group_id = params[:group_id]
    else
      redirect_to groups_path
    end
  end

  def show
    get_tracks
  end

  def get_tracks
    @tracks = CONNECTOR.connection(user: current_user).get_all_tracks
    @track_names = @tracks.reduce([]) do |accu, track|
      accu << track.name
    end
  end

  def edit
  end

  def join
    UserMessageService.send_system_group_message(current_user.name +
      " ist der Veranstaltung " + @event.name +
      " beigetreten.", @event.group)
    current_user.events << @event
    current_user.save
    flash[:success] = "You successfully joined #{@event.name}."
    redirect_to :back
  end

  def leave
    current_user.events.delete(@event)
    UserMessageService.send_system_group_message(current_user.name +
      " ist aus der Veranstaltung " + @event.name +
      " ausgetreten.", @event.group)
    flash[:success] = "You successfully left #{@event.name}."
    redirect_to :back
  end

  def create
    @event = Event.new(event_params)
    @event.track = params[:track]
    @event.users << current_user
    @event.group_id = params[:group_id]
    if @event.save
      flash[:success] = "Event #{@event.name} was successfully created."
      redirect_to @event.group
    else
      render 'new', group_id: @event.group.id
    end
  end

  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_event
    if params[:id]
      @event = Event.find(params[:id])
    end

    if params[:event_id]
      @event = Event.find(params[:event_id])
    end
  end

  def event_params
    params.require(:event).permit(:name, :details, :picture)
  end

end
