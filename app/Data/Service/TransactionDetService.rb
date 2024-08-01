class TransactionDetService
  def initialize
    @repository = TransactionDetsRepository.new
  end

  def get_all_by_transaction_id(transaction_id)
    @repository.get_all_by_transaction_id(transaction_id)
  end
  def get_by_product_and_transaction(product_id:, transaction_id:)
    @repository.get_by_product_and_transaction(product_id: product_id, transaction_id: transaction_id)
  end

  def get_by_id(id)
    @repository.get_by_id(id)
  end

  def create_transaction_detail(attributes)

    transaction_detail = @repository.create(attributes)
    transaction_detail.id
  end
  def update_transaction_detail(id,attributes)
    transaction_detail = @repository.update(id,attributes)
    transaction_detail.id
  end

  private

  
end