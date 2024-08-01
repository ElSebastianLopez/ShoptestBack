class Delivery < ApplicationRecord
  belongs_to :transaction, foreign_key: 'transaction_ref_id'
  #belongs_to :order_transaction, class_name: 'Transaction', foreign_key: 'transaction_id'
end