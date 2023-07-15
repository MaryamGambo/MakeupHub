class Product < ApplicationRecord
  belongs_to :brand
  belongs_to :type
  belongs_to :category
  has_many :orders, through: :order_items
end
