class Product < ApplicationRecord
  belongs_to :brand
  belongs_to :type
  belongs_to :category
  has_many :orders, through: :order_items
  has_and_belongs_to_many :tags
  has_one_attached :image

  validates :name, :price, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
end
