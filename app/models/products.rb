class Products < ApplicationRecord
  has_many :transaction_details

  validates :name, presence: true
  validates :price, presence: true
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }
end