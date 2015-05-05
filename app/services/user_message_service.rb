class UserMessageService
  include System

  def send_system_messages(message, reciever_ids)
    self.send_messages(message, System.system_user, reciever_ids)
  end
  
  def self.send_messages(message, sender, reciever_ids)
    sender = IdHelper::to_id(sender)
    reciever_ids.each do |reciever_id|
      UserMessage.create(message: message, sender_id: sender, reciever_id: reciever_id)
    end
  end
  
  def self.send_group_message(message, sender, group)
    if group.kind_of? Integer then group = Group.find(group_id) end
    members = group.users.pluck(:id)
    self.send_messages(message, sender, members)
  end

  def self.send_system_group_message(message, group)
    self.send_group_message(message, System.system_user.id, group)
  end
end
