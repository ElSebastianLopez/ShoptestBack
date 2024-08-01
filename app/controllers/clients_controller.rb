class ClientsController < ApplicationController
  def index
    service = ClientService.new
    clients = service.get_all_clients
    response = Response.new(success: true, data: clients.first, message: 'Ok')
    render json: response, status: :ok
  rescue ActiveRecord::RecordNotFound => e
    render json: { success: false, message: 'No se encuentran clientes', errors: [e.message] }, status: :not_found
  rescue StandardError => e
    # Captura cualquier otro error que podría causar un error 500
    render json: { success: false, message: 'Error en el servidor', errors: [e.message] }, status: :internal_server_error
  end

  def show
    service = ClientService.new
    clients = service.get_clients(params[:id])
    if clients
      response = Response.new(success: true, data: clients, message: 'Ok')
       render json: response, status: :ok
    else
      response = Response.new(success: false, data: clients, message: 'No se encontro un cliente con este id')
      render json: response, status: :not_found
    end
  rescue StandardError => e
    # Captura cualquier otro error que podría causar un error 500
    render json: { success: false, message: 'Error en el servidor', errors: [e.message] }, status: :internal_server_error
  end

end
