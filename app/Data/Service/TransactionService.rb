class TransactionService
  def initialize
    @repository = TransactionsRepository.new
    @transaction_det_repository = TransactionDetsRepository.new
    @client_repository=ClientsRepository.new
    @product_repository=ProductsRepository.new
  end

  def get_all_by_client_id(client_id)
    @repository.get_all_by_client_id(client_id)
  end

  def get_open_transaction_by_client_id(client_id)
    @repository.get_open_transaction_by_client_id(client_id)
  end

  def get_transaction(id)
    @repository.get_by_id(id)
  end

  def create_or_update_transaction_detail(client_id, attributes)
    Rails.logger.debug("Parametros 2: #{attributes.inspect}")
    Rails.logger.debug("Parametros 1: #{client_id}")
    validate_detail_attributes(client_id,attributes)

    # Buscar una transacción abierta existente
    open_transaction = @repository.get_open_transaction_by_client_id(client_id)

    # Calcular la base fee
    base_fee = attributes[:quantity].to_i * attributes[:price].to_f

    # Si no existe una transacción abierta, crear una nueva
    unless open_transaction
      open_transaction = create_new_transaction({
        client_id: client_id,
        transaction_date: Time.current,
        status: 'open',
        total_amount: base_fee,  # Inicialmente el total_amount será base_fee
        base_fee: base_fee,      # Asignar base_fee
        delivery_fee: 0,
        transaction_number: 0,
      })
    else
      # Si existe una transacción abierta, actualizar base_fee y total_amount
      open_transaction.update(
        base_fee: open_transaction.base_fee + base_fee,
        total_amount: open_transaction.total_amount + base_fee
      )
    end

    Rails.logger.debug("Quiero saber si me está devolviendo el id: #{open_transaction.inspect}")

    # Crear o actualizar el detalle de la transacción
    existing_detail = @transaction_det_repository.get_by_product_and_transaction(product_id: attributes[:product_id], transaction_id: open_transaction.id)
    Rails.logger.debug("Quiero saber existing_detail : #{existing_detail.inspect}")
    if existing_detail
      # Si el detalle ya existe, actualizar la cantidad y el precio usando el servicio
      new_quantity = existing_detail.quantity + attributes[:quantity].to_i
      new_total_price = existing_detail.price.to_f + (attributes[:quantity].to_i * attributes[:price].to_f)

      updated_detail = @transaction_det_repository.update(existing_detail.id, {
        quantity: new_quantity,
        price: new_total_price
      })
      detail_id = updated_detail
    else
      # Crear un nuevo detalle de la transacción
      detail_attributes = {
        product_id: attributes[:product_id],
        quantity: attributes[:quantity],
        price: base_fee,  # Aquí el precio es el total calculado
        transaction_id: open_transaction.id
      }
      Rails.logger.debug("Quiero saber qué está creando en el detalle: #{detail_attributes.inspect}")
      detail_id = @transaction_det_repository.create(detail_attributes)
    end

    Response.new(success: true, data: detail_id, message: 'Detalle de transacción creado correctamente')
  rescue StandardError => e
    Response.new(success: false, message: 'Error en el servidor: ' + e.message)
  end

  def create_new_transaction(attributes)
    transaction = @repository.create(attributes)

  end

  private

  
  def validate_detail_attributes(client_id,attributes)
    # Validar existencia del cliente
    client = @client_repository.get_by_id(client_id)
    raise 'El cliente no existe' unless client
  
    # Validar existencia del producto
    product = @product_repository.get_by_id(attributes[:product_id])
    raise 'El producto no existe' unless product
  
    # Validar cantidad
    raise 'La cantidad debe ser mayor que cero' if attributes[:quantity].to_i <= 0
  
    # Validar precio
    raise 'El precio debe ser mayor que cero' if attributes[:price].to_f <= 0
  end

 
end