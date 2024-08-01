class TransactionDetsRepository
  def initialize
    @model = TransactionDetails
  end

  def get_all
    @model.all
  end

  def get_by_id(id)
    @model.find_by(id: id)
  end

  def get_all_by_transaction_id(transaction_id)
    @model.includes(:products).where(transaction_id: transaction_id)
  end
  def get_by_product_and_transaction(attributes)
    @model.find_by(transaction_id: attributes[:transaction_id], product_id: attributes[:product_id])
  end

  def create(attributes)
    transaction_detail = @model.new(attributes)
    Rails.logger.debug("Quiero saber qUE QUIERE GUARDAR: #{transaction_detail.inspect}")
    if transaction_detail.save
      transaction_detail
    else
      # Manejar el error, por ejemplo, registrar un mensaje o lanzar una excepción
      raise StandardError, "Error al guardar el detalle de la transacción: #{transaction_detail.errors.full_messages.join(', ')}"
    end
  end

  def update(id, attributes)
    transaction_detail = @model.find_by(id: id)
    return nil unless transaction_detail
    
    transaction_detail.update(attributes)
    transaction_detail
  end
end