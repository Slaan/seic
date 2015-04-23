class GroupMessage < ActiveRecord::Base

  validates :message, presence: true, length: { minimum: 1, maximum: 300 }
  
  belongs_to :user
  belongs_to :group
end
