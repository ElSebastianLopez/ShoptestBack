# app/Data/Service/ProductService.rb
class ProductService
  def initialize
    @repository = ProductsRepository.new
  end

  def get_all_products
    @repository.get_all
  end

  def get_product(id)
    @repository.get_by_id(id)
  end

  def update_product(id, params)
    @repository.update(id, params)
  end

   def update_quantity(id, new_quantity)
    product = @repository.get_by_id(id)
    return false unless product

    product.quantity = new_quantity
    @repository.update(id, { quantity: new_quantity })
  end
end
