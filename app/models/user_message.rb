class UserMessage < ActiveRecord::Base

  belongs_to :sender, :class_name => 'User', :foreign_key => 'sender_id'
  belongs_to :reciever, :class_name => 'User', :foreign_key => 'reciever_id'

  validates :message, presence: true
  validates :sender, presence: true
  validates :reciever, presence: true

end
