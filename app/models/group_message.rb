class GroupMessage < ActiveRecord::Base

  validates :message, presence: true, length: { minimum: 1, maximum: 300 }
  validates :user_id, presence: true
  validates :group_id, presence: true

  default_scope -> { order(created_at: :desc) }
  
  belongs_to :user
  belongs_to :group
end
