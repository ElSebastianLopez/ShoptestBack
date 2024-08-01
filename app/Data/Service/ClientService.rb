class ClientService
  def initialize
    @repository = ClientsRepository.new
  end

  def get_all_clients
    @repository.get_all
  end

  def get_clients(id)
    @repository.get_by_id(id)
  end

 
end
