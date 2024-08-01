class TransactionsController < ApplicationController
  before_action :set_services

  # Método para obtener todas las transacciones por client_id
  def index_by_client
    begin
      client_id = params[:client_id]
      transactions = @transaction_service.get_all_by_client_id(client_id)
      response = Response.new(success: true, data: transactions, message: 'Transacciones obtenidas correctamente')
      render json: response, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      response = Response.new(success: false, message: 'No se encuentran transacciones para el cliente')
      render json: response, status: :not_found
    rescue StandardError => e
      response = Response.new(success: false, message: 'Error en el servidor: ' + e.message)
      render json: response, status: :internal_server_error
    end
  end

  def index_open_by_client
    begin
      client_id = params[:client_id]
      transactions = @transaction_service.get_open_transaction_by_client_id(client_id)
      response = Response.new(success: true, data: transactions, message: 'Transacciones obtenidas correctamente')
      render json: response, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      response = Response.new(success: false, message: 'No se encuentran transacciones para el cliente')
      render json: response, status: :not_found
    rescue StandardError => e
      response = Response.new(success: false, message: 'Error en el servidor: ' + e.message)
      render json: response, status: :internal_server_error
    end
  end

  # Método para obtener todos los detalles de transacción por transaction_id
  def index_by_transaction
    begin
      transaction_id = params[:transaction_id]
      transaction_details = @transaction_det_service.get_all_by_transaction_id(transaction_id)
      transaction_details_json = transaction_details.as_json(include: :products)
      response = Response.new(success: true, data: transaction_details_json, message: 'Detalles de transacciones obtenidos correctamente')
      render json: response, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      response = Response.new(success: false, message: 'No se encuentran detalles para la transacción')
      render json: response, status: :not_found
    rescue StandardError => e
      response = Response.new(success: false, message: 'Error en el servidor: ' + e.message)
      render json: response, status: :internal_server_error
    end
  end

  skip_before_action :verify_authenticity_token, only: [:create_transaction_detail]
  # Método para crear detalle de transacción
 
  
  # def create_transaction_detail
  #   begin
  #     # Extraer y validar los atributos del detalle de transacción
  #     attributes = transaction_params
  #     validate_detail_attributes(attributes)
  
  #     # Utiliza el client_id extraído
  #     client_id = @client_id
  
  #     # Buscar una transacción abierta existente
  #     open_transaction = @transaction_service.get_open_transaction_by_client_id(client_id)
  
  #     # Calcular la base fee
  #     base_fee = attributes[:quantity].to_i * attributes[:price].to_f
  
  #     # Si no existe una transacción abierta, crear una nueva
  #     unless open_transaction
  #       open_transaction = @transaction_service.create_new_transaction({
  #         client_id: client_id,
  #         transaction_date: Time.current,
  #         status: 'open',
  #         total_amount: base_fee,  # Inicialmente el total_amount será base_fee
  #         base_fee: base_fee,      # Asignar base_fee
  #         delivery_fee: 0,
  #         transaction_number: 0,
  #       })
  #     else
  #       # Si existe una transacción abierta, actualizar base_fee y total_amount
  #       open_transaction.update(
  #         base_fee: open_transaction.base_fee + base_fee,
  #         total_amount: open_transaction.total_amount + base_fee
  #       )
  #     end
  
  #     Rails.logger.debug("Quiero saber si me está devolviendo el id: #{open_transaction.inspect}")
      
  #     # Crear o actualizar el detalle de la transacción
  #     existing_detail = @transaction_det_service.get_by_product_and_transaction(product_id: attributes[:product_id],transaction_id: open_transaction)
  #     Rails.logger.debug("Quiero saber existing_detail : #{existing_detail.inspect}")
  
  #     if existing_detail
  #       # Si el detalle ya existe, actualizar la cantidad y el precio usando el servicio
  #       new_quantity = existing_detail.quantity + attributes[:quantity].to_i
  #       new_total_price = existing_detail.price.to_f + (attributes[:quantity].to_i * attributes[:price].to_f)
  
  #       updated_detail = @transaction_det_service.update_transaction_detail(existing_detail.id, {
  #         quantity: new_quantity,
  #         price: new_total_price
  #       })
  #       detail_id = updated_detail
  #     else
  #       # Crear un nuevo detalle de la transacción
  #       detail_attributes = {
  #         product_id: attributes[:product_id],
  #         quantity: attributes[:quantity],
  #         price: base_fee,  # Aquí el precio es el total calculado
  #         transaction_id: open_transaction.id
  #       }
  #       Rails.logger.debug("Quiero saber qué está creando en el detalle: #{detail_attributes.inspect}")
  #       detail_id = @transaction_det_service.create_transaction_detail(detail_attributes)
  #     end
  
  #     response = Response.new(success: true,data:detail_id, message: 'Detalle de transacción creado correctamente')
  #     render json: response, status: :ok
  #   rescue StandardError => e
  #     response = Response.new(success: false, message: 'Error en el servidor: ' + e.message)
  #     render json: response, status: :internal_server_error
  #   end
  # end
  def create_transaction_detail
    attributes = transaction_params
    client_id = @client_id

    response = @transaction_service.create_or_update_transaction_detail(client_id, attributes)
    render json: response, status: response.success ? :ok : :internal_server_error
  end
  
  

  private

  def set_services
    @transaction_service = TransactionService.new
    @transaction_det_service = TransactionDetService.new
  end

  def validate_detail_attributes(attributes)
    raise "Product ID is required" unless attributes[:product_id]
    raise "Quantity is required" unless attributes[:quantity]
    raise "Price is required" unless attributes[:price]
    raise "Client ID is required" unless @client_id
  end

  def transaction_params
    # Extraer los parámetros del modelo TransactionDetail
    params.require(:transaction_detail).permit(:product_id, :quantity, :price).tap do |transaction_params|
      # Extraer el client_id directamente desde los parámetros
      @client_id = params.dig(:transaction_detail, :client_id)
      Rails.logger.debug("Quiero ver los parametros solo el i cliente: #{@client_id}")
    end
  end
end
