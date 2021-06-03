module ExceptionHandler
  extend ActiveSupport::Concern
  class DecodeError < StandardError; end
  class ExpiredSignature < StandardError; end
  included do
    rescue_from ExceptionHandler::DecodeError do |_error|
      render json: {
        status: 401,
        message: "Access denied!. Invalid token supplied.",
        data: nil
      }, status: :unauthorized
    end
    rescue_from ExceptionHandler::ExpiredSignature do |_error|
      render json: {
        status: 401,
        message: "Access denied!. Token has expired.",
        data: nil
      }, status: :unauthorized

    end
  end
end