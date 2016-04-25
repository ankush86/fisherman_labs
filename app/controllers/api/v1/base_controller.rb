class Api::V1::BaseController < ActionController::Base
  rescue_from Exception, with: :exception_handling
  protect_from_forgery with: :null_session
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

  respond_to :json
  
  class MissingParameter < StandardError
  end

  rescue_from MissingParameter do |exception|
    render json: {:success => false, :message => "#{@param_name} is required!"}, status: 500
  end

  def authorize_valid_tokens
    render invalid_token unless valid_token?
  end

  # Return invalid token json
  def invalid_token(message)
    {json: {:message => message}}
  end

  # Check if token is valid
  def valid_token?
    token_validator = TokenValidator.new(request.headers['token'])
    @user ||= token_validator.user
    return token_validator.valid_jwt_token?
  end

  protected

  def exception_handling(e)
    render invalid_token(e.message)
  end

  def handle_exception(message)
    render json: {:success => false, :message => message}, status: 500
  end
  
  def prepare!(required_params)
    required_params.each do |param_name|
      if params[param_name].blank?
        @param_name = param_name
        raise MissingParameter
      end
    end
  end

end
