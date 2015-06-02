class Event < ActiveRecord::Base
  mount_uploader :picture, PictureUploader

  validates :name, presence: true, length: { maximum: 50 }, uniqueness: true
  validates :details, presence: true, length: { maximum: 250 }

  validate  :picture_size

  belongs_to :group
  has_and_belongs_to_many :users

  CONNECTOR = ConnectorFactory.connection

  def get_tracks
    @tracks = TracksDeserializerMark.deserialize_all(CONNECTOR.connection(current_user).get_all_tracks.body)
  end

  def is_member?(user_id)
    users.where("id = ?", user_id).size > 0
  end

  private

  # Validates the size of an uploaded picture.
  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "should be less than 5MB")
    end
  end

end
