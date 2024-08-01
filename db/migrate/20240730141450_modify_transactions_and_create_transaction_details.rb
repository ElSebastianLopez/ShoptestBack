class ModifyTransactionsAndCreateTransactionDetails < ActiveRecord::Migration[7.1]
  def change
    # Remover la referencia a los productos de la tabla de transacciones
    remove_reference :transactions, :product, foreign_key: true

    # Crear la tabla de detalles de transacciones
    create_table :transaction_details do |t|
      t.references :transaction, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :quantity
      t.decimal :price

      t.timestamps
    end
  end
end
