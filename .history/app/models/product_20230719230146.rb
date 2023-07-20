class Product < ApplicationRecord
  belongs_to :brand
  belongs_to :type
  belongs_to :category
  has_many :order_items
  has_many :orders, through: :order_items
  has_and_belongs_to_many :tags
  has_one_attached :image

  validates :name, :price, :description, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :on_sale_status, inclusion: { in: [true, false] }
end
