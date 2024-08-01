# app/controllers/products_controller.rb
class ProductsController < ApplicationController
  def index
    service = ProductService.new
    @products = service.get_all_products
    @response = Response.new(success: true, data: @products, message: 'Ok')
    render json: @response, status: :ok
  rescue ActiveRecord::RecordNotFound => e
    render json: { success: false, message: 'No se encuentran productos', errors: [e.message] }, status: :not_found
  rescue StandardError => e
    # Captura cualquier otro error que podría causar un error 500
    render json: { success: false, message: 'Error en el servidor', errors: [e.message] }, status: :internal_server_error
  end

  def show
    service = ProductService.new
    @product = service.get_product(params[:id])
    if @product
       @response = Response.new(success: true, data: @product, message: 'Ok')
       render json: @response, status: :ok
    else
      @response = Response.new(success: false, data: @product, message: 'No se encontro un producto con este id')
      render json: @response, status: :not_found
    end
  rescue StandardError => e
    # Captura cualquier otro error que podría causar un error 500
    render json: { success: false, message: 'Error en el servidor', errors: [e.message] }, status: :internal_server_error
  end

  protect_from_forgery with: :null_session
  def update
    service = ProductService.new
    @res=service.update_quantity(params[:id], product_params[:quantity])
    if @res
      # head :no_content
      @response = Response.new(success: true, data: @res, message: 'Se actualizo la cantidad de el producto')
      render json: @response, status: :ok
    else
      render json: { error: 'Error al actualizar la cantidad de el producto' }, status: :unprocessable_entity
    end
  rescue StandardError => e
    # Captura cualquier otro error que podría causar un error 500
    render json: { success: false, message: 'Error en el servidor', errors: [e.message] }, status: :internal_server_error
  end

  private

  def product_params
    params.require(:product).permit(:quantity)
  end
end
