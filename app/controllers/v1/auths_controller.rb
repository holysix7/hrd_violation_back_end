class V1::AuthsController < ApplicationController
  def create
    @user = SysAccount.find_by(user: params[:user])
    if @user.present? and @user.password_clear == params[:password]
      @token = JsonWebToken.encode(@user.as_json)
      render json: {
        status: "Success",
        code: 200,
        token: @token,
        data: @user
      }
    else
      render json: {
        status: "Failed",
        code: 400,
        message: "Login Failed",
        token: nil,
        data: nil
      }
    end
  end
  
  def destroy
    
  end  

  def auto_login
    render json: @user
  end

end