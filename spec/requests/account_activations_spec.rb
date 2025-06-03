# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AccountActivations' do
  let(:user) { FactoryBot.create(:user, activated: false, activated_at: nil) }

  describe 'GET /edit' do
    subject(:get_edit) { get edit_account_activation_path(activation_token, email: user_email) }

    before { get_edit }

    context 'with valid token and email' do
      let(:activation_token) { user.activation_token }
      let(:user_email) { user.email }

      it 'activates the user', :aggregate_failures do
        user.reload
        expect(user.activated?).to be true
        expect(session[:user_id]).to eq user.id
        expect(response).to redirect_to user
        expect(flash[:success]).to be_present
      end
    end

    context 'with invalid token' do
      let(:activation_token) { 'invalid_token' }
      let(:user_email) { user.email }

      it 'does not activate the user', :aggregate_failures do
        user.reload
        expect(user.activated?).to be false
        expect(session[:user_id]).to be_nil
        expect(response).to redirect_to root_url
        expect(flash[:danger]).to be_present
      end
    end

    context 'with invalid email' do
      let(:activation_token) { user.activation_token }
      let(:user_email) { 'wrong@example.com' }

      it 'does not activate the user', :aggregate_failures do
        user.reload
        expect(user.activated?).to be false
        expect(session[:user_id]).to be_nil
        expect(response).to redirect_to root_url
        expect(flash[:danger]).to be_present
      end
    end
  end
end
