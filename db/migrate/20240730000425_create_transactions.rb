class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.references :client, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.datetime :transaction_date
      t.string :status
      t.decimal :total_amount
      t.decimal :base_fee
      t.decimal :delivery_fee
      t.string :transaction_number

      t.timestamps
    end
    add_index :transactions, :transaction_number
  end
end
