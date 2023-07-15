class Customer < ApplicationRecord
  belongs_to :primary_province, class_name: 'Province'
  belongs_to :alt_province, class_name: 'Province'

  validates :first_name, :last_name, :password,  presence: true
  validates :password, length: { minimum: 6 }
  validates :primary_postal_code,:alt_postal_code, format: { with: /\A[A-Za-z]\d[A-Za-z] \d[A-Za-z]\d\z/, message: "is not a valid Canadian postal code" }
end
