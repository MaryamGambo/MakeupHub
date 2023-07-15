class Order < ApplicationRecord
  belongs_to :customer
  has_many :products, through: :order_items

  validates :order_date, presence: true
end
