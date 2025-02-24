# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions' do
  shared_examples 'invalid login attempt' do
    it 'does not log in the user' do
      subject

      expect(session[:user_id]).to be_nil
      expect(response).to render_template(:new)
      expect(flash[:danger]).to be_present
    end
  end

  describe 'GET /login' do
    it 'renders login page' do
      get login_path
      expect(response).to render_template(:new)
    end
  end

  describe 'POST /login' do
    let(:user) { FactoryBot.create(:user) }

    subject { post login_path, params: params }

    context 'with valid information' do
      let(:params) do
        {
          session: {
            email: user.email,
            password: 'password',
            remember_me: '1'
          }
        }
      end

      it 'logs in the user' do
        subject

        expect(session[:user_id]).to eq user.id
        expect(cookies[:remember_token]).to be_present
        expect(response).to redirect_to user
      end

      it 'redirects to the forwarding url if exists' do
        get users_path
        expect(session[:forwarding_url]).to eq users_url

        subject

        expect(response).to redirect_to users_url
        expect(session[:forwarding_url]).to be_nil
      end
    end

    context 'with invalid information' do
      let(:params) { { session: { email: '' } } }

      include_examples 'invalid login attempt'
    end

    context 'with valid email but invalid password' do
      let(:params) do
        {
          session: {
            email: user.email,
            password: 'wrong'
          }
        }
      end

      include_examples 'invalid login attempt'
    end
  end

  describe 'DELETE /logout' do
    let(:user) { FactoryBot.create(:user) }

    before do
      log_in_as(user)
    end

    it 'logs out the user' do
      expect(session[:user_id]).to eq user.id

      delete logout_path

      expect(session[:user_id]).to be_nil
      expect(cookies[:remember_token]).to be_empty
      expect(response).to redirect_to root_url
    end
  end
end
