class Customer < ApplicationRecord
  belongs_to :primary_province, class_name: 'Province'
  belongs_to :alt_province, class_name: 'Province'

  validates :first_name, :last_name, :password,  presence: true
  validates :password, length: { minimum: 6 }
  validates :primary_postal_code, presence: true, format: { with: /\A\d{5}\z/, message: "should be a 5-digit number" }
end
