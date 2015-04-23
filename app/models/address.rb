class Address < ActiveRecord::Base

  validates :street, presence: true, length: { maximum: 100 }
  validates :house_number, presence: true, length: { maximum: 10 }
  validates :city, presence: true, length: { maximum: 50 }
  validates :state, presence: true, length: { maximum: 50 }
  validates :postcode, presence: true, length: { maximum: 20 }
  validates :country, presence: true, length: { maximum: 50 }
  
  has_one :user
end
