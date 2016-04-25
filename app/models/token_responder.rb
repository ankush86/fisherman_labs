class TokenResponder
  attr_reader :user

  def initialize user
    @user = user
  end

  def invalid_token
    {:message => "Invalid Username/Password"}
  end

  def user_token
    user.present? ? valid_token : invalid_token
  end

  def valid_token
    {"token" => generate_valid_tokens(user) }
  end

  def generate_valid_tokens(user)
    @token = JWT.encode(user_data, nil, 'none')
  end

  def user_data
    {user.id.to_s => user.email.to_s}
  end
end
