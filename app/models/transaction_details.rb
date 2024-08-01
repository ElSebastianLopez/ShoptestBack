class TransactionDetails < ApplicationRecord
  belongs_to :transaction_association, class_name: 'Transaction', foreign_key: 'transaction_id'
 belongs_to :products, class_name: 'Products', foreign_key: 'product_id'
end
