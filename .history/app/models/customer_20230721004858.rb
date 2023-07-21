class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :primary_province, class_name: 'Province', optional: true
  belongs_to :alt_province, class_name: 'Province', optional: true
  has_many :orders

  # Custom validation method to check Canadian postal code format
def canadian_postal_code_format
  if primary_postal_code.present? && !primary_postal_code.match(/\A[A-Za-z]\d[A-Za-z] \d[A-Za-z]\d\z/)
    errors.add(:primary_postal_code, "is not a valid Canadian postal code")
  end

  if alt_postal_code.present? && !alt_postal_code.match(/\A[A-Za-z]\d[A-Za-z] \d[A-Za-z]\d\z/)
    errors.add(:alt_postal_code, "is not a valid Canadian postal code")
  end
end

  validates :first_name, :last_name, length: { maximum: 100 }
  validates :primary_address, :primary_city, :alt_address, :alt_city, allow_nil: true, length: { maximum: 100 }
  validates :canadian_postal_code_format, if: -> { primary_postal_code.present? || alt_postal_code.present? }


end
