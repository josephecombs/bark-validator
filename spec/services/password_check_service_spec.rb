require 'rails_helper'

RSpec.describe PasswordCheckService do
  describe '.valid_length?' do
    context 'when password is of valid length' do
      it 'returns true' do
        expect(PasswordCheckService.valid_length?('ValidPassword')).to be true
      end
    end

    context 'when password is too short' do
      it 'returns false' do
        expect(PasswordCheckService.valid_length?('short')).to be false
      end
    end
  end

  describe '.pwned?' do
    context 'when password has not been pwned' do
      it 'returns false' do
        allow(Net::HTTP).to receive(:get).and_return("00000:2\r\n11111:0")
        expect(PasswordCheckService.pwned?('NewPassword')).to be false
      end
    end

    context 'when password has been pwned' do
      it 'returns true' do
        suffix = Digest::SHA1.hexdigest('password')[5..-1].upcase
        allow(Net::HTTP).to receive(:get).and_return("#{suffix}:2\r\n11111:0")
        expect(PasswordCheckService.pwned?('password')).to be true
      end
    end
  end
end
