class Order < ApplicationRecord
  belongs_to :customer
  has_many :products, through: :order_items
end
