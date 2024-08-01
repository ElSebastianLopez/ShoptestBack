# app/Data/Repository/ProductsRepository.rb
class ClientsRepository
  def initialize
    @model = Client
  end

  def get_all
    @model.all
  end

  def get_by_id(id)
    @model.find_by(id: id)
  end
end
