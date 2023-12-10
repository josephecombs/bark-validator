require 'net/http'
require 'json'

class PasswordCheckService
  PWNED_API_URL = 'https://api.pwnedpasswords.com/range/'.freeze
  MIN_PASSWORD_LENGTH = 8

  def self.valid_length?(password)
    password.length >= MIN_PASSWORD_LENGTH
  end

  def self.pwned?(password)
    hash = Digest::SHA1.hexdigest(password).upcase
    range = hash[0...5]
    suffix = hash[5..-1]

    uri = URI("#{PWNED_API_URL}#{range}")
    response = Net::HTTP.get(uri)

    response.split("\r\n").any? { |line| line.split(':')[0] == suffix }
  end
end
