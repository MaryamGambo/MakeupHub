class Customer < ApplicationRecord
  belongs_to :primary_province
  belongs_to :alt_province
end
