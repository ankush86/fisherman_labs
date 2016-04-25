class Api::V1::UsersController < Api::V1::BaseController
  
  respond_to :json
  
  def sign_up
    begin
      user = User.new(user_params)
      if user.save
        render json: {:token => user.authorize, :success => true, :message => "User SignUp Successfully"}
        return
      else
        warden.custom_failure!
        render json: {:status => false, :error => user.errors.as_json}
      end
    rescue => e
      handle_exception(e.message)
    end
  end

  def sign_in
    login = params[:user][:email] || params[:user][:mobile_no]
    user = User.where(["email = :value", { :value => login.downcase }]).first
    if !user.blank?
      if user.valid_password?(params[:user][:password])
        render json: {:token => user.authorize, :success => true, :message => "User login Successfully"}
      else
        render json: {:success => false, :message => "Password has been incorrect"}  
      end  
    else
      render json: {:success => false, :message => "Email and password has been incorrect"}
    end
  end
  
  def show
    prepare!([:id])
    begin
      user = User.find(params[:id])
      if user.present?
        render json: user.as_json
      else
        render json: {:status => false, :error => user.errors.as_json}
      end
    rescue => e
      handle_exception(e.message)
    end
  end
  
  def update
    prepare!([:id])
    begin
      user = User.find(params[:id])
      if user.update_attributes(user_params)
        render json: { :success => true, :message => I18n.t('devise.registrations.updated')}
      else
        render json: {:success => false, :error => user.errors.as_json}
      end
    rescue => e
      handle_exception(e.message)
    end
  end

  def forgot_password
    begin
      user = User.where(:email => params[:user][:email]).first
      if user.blank?
        render json: {:success => false, :message => "Email could not be found"}
      else
        user.send_reset_password_instructions
        render json: {:success => true, :message => I18n.t('devise.passwords.send_instructions')}
      end
    rescue => e
      handle_exception(e.message)
    end
  end

  def facebook
    begin
      auth = OpenStruct.new
      auth.provider = params[:user][:provider]
      auth.uid = params[:user][:uid]
      auth.info = OpenStruct.new
      auth.info.email = params[:user][:email]
      auth.info.verified = true
      auth.extra = OpenStruct.new
      auth.extra.raw_info = OpenStruct.new
      auth.extra.raw_info.name = params[:user][:name]
      

      identity = Identity.find_for_oauth(auth)

      if !identity.user.blank?
        if identity.user.persisted?
          render json: {:token => identity.user.authorize, :success => true, :message => "User login Successfully via Facebook"}
        end
      elsif auth.info.email.blank?
        auth.info.email = "#{request.env["omniauth.auth"]["uid"]}@#{request.env["omniauth.auth"]["provider"]}.com"
        user = User.find_for_oauth_api(auth)
        render json: { :success => false, :message => "Please Enter your email"}
      else
        user = User.find_for_oauth(auth)
        render json: {:token => user.authorize, :success => true, :message => "User SignUp Successfully via Facebook"}
      end
    rescue => e
      handle_exception(e.message)
    end
  end

  private

  def user_params
    params.require(:user).permit(:id, :name, :email, :password, :password_confirmation, :uid, :provider, :token)
  end
  
end
