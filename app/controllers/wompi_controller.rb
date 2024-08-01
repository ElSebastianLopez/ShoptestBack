class WompiController < ApplicationController
  def get_merchant_details
    wompi_service = WompiService.new
    merchant_details = wompi_service.get_merchant_details

    if merchant_details[:error].nil?
      response = Response.new(success: true, data: merchant_details, message: 'Detalles del comerciante obtenidos correctamente')
      render json: response, status: :ok
    else
      response = Response.new(success: false, message: 'Error al obtener detalles del comerciante: ' + merchant_details[:error])
      render json: response, status: :not_found
    end
  rescue StandardError => e
    response = Response.new(success: false, message: 'Error en el servidor: ' + e.message)
    render json: response, status: :internal_server_error
  end
end
