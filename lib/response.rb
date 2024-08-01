# app/lib/response.rb
class Response
  attr_reader :success, :data, :message

  def initialize(success:, data: nil, message: '')
    @success = success
    @data = data
    @message = message
  end

  def to_h
    {
      success: @success,
      data: @data,
      message: @message
    }
  end
end