class Province < ApplicationRecord
  has_many :customers

  validates :name, :tax_type, presence: true
  validates :gst, :pst, :hst, numericality: { greater_than_or_equal_to: 0 }
end
