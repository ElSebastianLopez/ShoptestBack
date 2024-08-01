class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :Name
      t.string :Description
      t.decimal :Price
      t.string :url
      t.integer :quantity

      t.timestamps
    end
  end
end
