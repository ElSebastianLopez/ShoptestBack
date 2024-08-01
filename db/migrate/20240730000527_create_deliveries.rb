class CreateDeliveries < ActiveRecord::Migration[7.1]
  def change
    create_table :deliveries do |t|
      t.references :transaction, null: false, foreign_key: true
      t.string :delivery_status, null: false
      t.datetime :shipping_date
      t.datetime :delivery_date

      t.timestamps
    end
  end
end
