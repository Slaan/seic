class User < ActiveRecord::Base
  include SearchCop

  after_validation { self.errors.messages.delete(:password_digest) }

  mount_uploader :picture, PictureUploader
  
  before_save { self.email = email.downcase }
  validates :name, presence: true
  validates :email, presence: true
  validates :name,  presence: true, length: { maximum: 50 }
  validates :username, presence: true, length: { maximum: 20 }
  validates :password_digest, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true,
                    length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 8 }, :allow_blank => true
  validate  :picture_size
  has_secure_password

  search_scope :search do
    attributes :name, :first_name, :username
  end
  
  belongs_to :address
  has_and_belongs_to_many :groups
  has_many :group_messages
  has_many :send_messages, :class_name => 'UserMessage', :foreign_key => 'sender_id'
  has_many :recieved_messages, :class_name => "UserMessage", :foreign_key => 'reciever_id'

  def self.group_membership(user)
    user.groups.pluck(:id)
  end

  private

    # Validates the size of an uploaded picture.
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end
  
end

