class User < ActiveRecord::Base
  include SearchCop
  
  before_save { self.email = email.downcase }
  validates :name, presence: true
  validates :email, presence: true
  validates :name,  presence: true, length: { maximum: 50 }
  validates :username, presence: true, length: { maximum: 20 }
  validates :password, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true,
                    length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 8 }, :allow_blank => true
  has_secure_password

  search_scope :search do
    attributes :name, :first_name, :username
  end
  
  belongs_to :address
  has_and_belongs_to_many :groups
  has_many :group_messages

  def self.group_membership(user)
    user.groups.pluck(:id)
  end
  
end
