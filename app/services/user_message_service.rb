class UserMessageService
  include System

  def self.send_messages(message, recievers)
    recievers.each do |reciever_id|
      UserMessage.create(message: message, sender_id: System.system_user.id, reciever_id: reciever_id)
    end
  end

end
