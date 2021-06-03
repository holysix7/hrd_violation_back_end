class JsonWebToken
  JWT_SECRET = "Fikri-Reformasi-Ganteng"
  
  def self.encode(payload, exp = 1.days.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, JWT_SECRET, 'HS256')
  end

  def self.decode(token)
    body = JWT.decode(token, JWT_SECRET, 'HS256')[0]
    HashWithIndifferentAccess.new body
    puts token
    rescue JWT::ExpiredSignature, JWT::VerificationError => e
      raise ExceptionHandler::ExpiredSignature, e.message
    rescue JWT::DecodeError, JWT::VerificationError => e
      raise ExceptionHandler::DecodeError, e.message
  end

end