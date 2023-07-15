class Province < ApplicationRecord
  has_many :customers

  validates :name, :tax_type, presence: true
  validates :GST, :PST, :HST, numericality: { greater_than_or_equal_to: 0 }
end
