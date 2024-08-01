# app/Data/Repository/ProductsRepository.rb
class ProductsRepository
  def initialize
    @model = Products
  end

  def get_all
    @model.all
  end

  def get_by_id(id)
    @model.find_by(id: id)
  end

  def update(id, attributes)
    product = get_by_id(id)
    return false unless product

    product.update(attributes)  # `attributes` debe ser un hash aquí
  end

  
end
