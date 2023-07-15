class Customer < ApplicationRecord
  belongs_to :primary_province, class_name: 'Province'
  belongs_to :alt_province, class_name: 'Province'
end
