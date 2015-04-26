class Group < ActiveRecord::Base
  include SearchCop

  mount_uploader :picture, PictureUploader
  
  validates :name, presence: true, length: { maximum: 50 }, uniqueness: true
  validates :details, presence: true, length: { maximum: 250 }

  validate  :picture_size
  
  has_and_belongs_to_many :users
  has_many :group_messages

  search_scope :search do
    attributes :name
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
