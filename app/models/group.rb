class Group < ActiveRecord::Base
  include SearchCop
  
  validates :name, presence: true, length: { maximum: 50 }
  validates :details, presence: true, length: { maximum: 250 }
  
  has_and_belongs_to_many :users
  has_many :group_messages

  search_scope :search do
    attributes :name
  end
  
end
