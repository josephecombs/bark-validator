require 'rails_helper'

RSpec.describe PasswordsController, type: :controller do
  let(:valid_password) { 'ValidPassword123!' }
  let(:short_password) { 'short' }
  let(:pwned_password) { 'password' } # Assuming 'password' is a known pwned password for testing

  describe 'GET #new' do
    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with a valid password' do
      it 'returns a success message' do
        allow_any_instance_of(PasswordCheckService).to receive(:valid_length?).and_return(true)
        allow_any_instance_of(PasswordCheckService).to receive(:pwned?).and_return(false)

        post :create, params: { password: valid_password }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq(PasswordCheckService::SUCCESS_MESSAGE)
      end
    end

    context 'with a password that is too short' do
      it 'returns an error message' do
        allow_any_instance_of(PasswordCheckService).to receive(:valid_length?).and_return(false)
        allow_any_instance_of(PasswordCheckService).to receive(:pwned?).and_return(false)
        allow_any_instance_of(PasswordCheckService).to receive(:response_message).and_return(PasswordCheckService::LENGTH_ERROR_MESSAGE)

        post :create, params: { password: short_password }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('Password is too short. It must be at least 8 characters.')
      end
    end

    context 'with a pwned password' do
      it 'returns an error message' do
        allow_any_instance_of(PasswordCheckService).to receive(:valid_length?).and_return(true)
        allow_any_instance_of(PasswordCheckService).to receive(:pwned?).and_return(true)
        allow_any_instance_of(PasswordCheckService).to receive(:response_message).and_return(PasswordCheckService::COMPROMISED_PASSWORD_ERROR)

        post :create, params: { password: pwned_password }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq(PasswordCheckService::COMPROMISED_PASSWORD_ERROR)
      end
    end
  end
end
