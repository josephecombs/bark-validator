require 'net/http'
require 'json'

class PasswordCheckService
  # TODO: make this more dynamic and prepared for possible future password complexity demands

  attr_accessor :response_message

  PWNED_API_URL = 'https://api.pwnedpasswords.com/range/'.freeze
  MIN_PASSWORD_LENGTH = 8
  LENGTH_ERROR_MESSAGE = 'Password is too short. It must be at least 8 characters.'.freeze
  SUCCESS_MESSAGE = 'Your password is secure and has not been compromised.'.freeze

  COMPROMISED_PASSWORD_ERROR = <<~ERROR_MESSAGE.strip.freeze
    For your security, please choose a different password.
    The one you entered has been exposed in a data breach,
    which increases the risk of unauthorized access to your accounts.
  ERROR_MESSAGE

  def valid_length?(password)
    if password.length >= MIN_PASSWORD_LENGTH
      @response_message = LENGTH_ERROR_MESSAGE
    end

    password.length >= MIN_PASSWORD_LENGTH
  end

  def pwned?(password)
    hash = Digest::SHA1.hexdigest(password).upcase
    range = hash[0...5]
    suffix = hash[5..-1]

    uri = URI("#{PWNED_API_URL}#{range}")
    response = Net::HTTP.get(uri)

    result = response.split("\r\n").any? { |line| line.split(':')[0] == suffix }
    if result
      @response_message = COMPROMISED_PASSWORD_ERROR
    else

    end

    result
  end
end
