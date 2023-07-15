class Order < ApplicationRecord
  belongs_to :customer
  has_many :products, through: :order_items

  validates :order_date, presence: true
  validates :GST, :HST, :PST, :total_amount, numericality: { greater_than_or_equal_to: 0 }
  validates :status, inclusion: { in: %w[pending paid shipped] }
end
