require "test_helper"

class ProductTest < ActiveSupport::TestCase
  def setup
    @product = Product.new(name: "Sample Product", description: "This is a sample product description", price: 10.99, url: "http://example.com/product", quantity: 5)
  end

  def teardown
    @product = nil
  end

  def test_product_is_valid
    assert @product.valid?
  end

  def test_product_is_invalid_without_name
    @product.name = nil
    assert_not @product.valid?
  end

  def test_product_is_invalid_without_price
    @product.price = nil
    assert_not @product.valid?
  end

  def test_product_is_invalid_with_negative_quantity
    @product.quantity = -1
    assert_not @product.valid?
  end

  def test_product_has_many_transaction_details
    assert_respond_to @product, :transaction_details
  end
end
