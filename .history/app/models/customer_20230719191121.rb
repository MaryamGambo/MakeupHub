class Customer < ApplicationRecord
  belongs_to :primary_province, class_name: 'Province', optional: true
  belongs_to :alt_province, class_name: 'Province', optional: true
  has_many :orders

  validates :first_name, :last_name, length: { maximum: 100 }
  validates :password, length: { minimum: 8 }
  validates :primary_postal_code,:alt_postal_code, allow_nil: true, format: { with: /\A[A-Za-z]\d[A-Za-z] \d[A-Za-z]\d\z/, message: "is not a valid Canadian postal code" }
  validates :primary_address, :primary_city, :alt_address, :alt_city, length: { maximum: 100 }
end
