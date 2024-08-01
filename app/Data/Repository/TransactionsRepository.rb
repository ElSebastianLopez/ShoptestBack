class TransactionsRepository
  def initialize
    @model = Transaction
  end

  def get_all
    @model.all
  end

  def get_by_id(id)
    @model.find_by(id: id)
  end

  def get_all_by_client_id(client_id)
    @model.where(client_id: client_id)
  end
  
  def get_open_transaction_by_client_id(client_id)
    @model.find_by(client_id: client_id, status: 'open')
  end

  def create(attributes)
    @model.create(attributes)
  end

  def update(id, attributes)
    transaction = @model.find_by(id: id)
    return unless transaction
    
    transaction.update(attributes)
    transaction
  end
end