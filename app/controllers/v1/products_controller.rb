class V1::ProductsController < ApplicationController
  def index
    JsonWebToken.decode(request.headers["Authorization"])
    @products = Product.all
    if @products
      render json: {
        status: "Success",
        code: 200,
        message: "Success Get Data Products",
        data: @products
      }
    else
      render json: {
        status: "Failed",
        code: 401,
        message: "There's No Data Products"
      }
    end
  end

  def create
    JsonWebToken.decode(request.headers["Authorization"])
    @product = Product.new(
      product_code: params[:product_code],
      product_name: params[:product_name],
      product_weight: params[:product_weight]
    )
    if params[:product_code].present? && params[:product_name].present? && params[:product_weight].present?
      @product.save
      render json: {
        status: "Success",
        code: 200,
        message: "Success Send Data Product",
        data: @product
      }
    else
      render json: {
        status: "Failed",
        code: 401,
        message: "Failed Send Data Product",
        data: @product
      }
    end
  end
  
  def destroy
    JsonWebToken.decode(request.headers["Authorization"])
    @product = Product.where(id: params[:id]).first
    if @product.present?
      render json: {
        status: "Success",
        code: 200,
        message: "Success Delete Data Product",
        data: @product
      }
      @product.destroy
    else
      render json: {
        status: "Failed",
        code: 400,
        message: "Failed Delete Data Product, Because There is No Such ID's Product"
      }
    end
      
  end
  
end
