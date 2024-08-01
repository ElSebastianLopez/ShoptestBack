class Transaction < ApplicationRecord
    belongs_to :client
  has_many :transaction_details, foreign_key: 'transaction_id'

  validates :client, presence: true
end
