# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PasswordResets' do
  before do
    ActionMailer::Base.deliveries.clear
  end

  shared_examples 'password reset validations' do
    let(:user) { FactoryBot.create(:user, :pending_password_reset) }

    context 'with wrong email' do
      let(:params) { { email: 'wrong@example.com' } }
      let(:reset_token) { user.reset_token }

      it 'redirects to root url', :aggregate_failures do
        make_request
        expect(response).to redirect_to root_url
        expect(flash[:danger]).to be_present
      end
    end

    context 'with inactive user' do
      let(:params) { { email: user.email } }
      let(:reset_token) { user.reset_token }

      it 'redirects to root url', :aggregate_failures do
        user.toggle!(:activated)
        make_request

        expect(response).to redirect_to root_url
        expect(flash[:danger]).to be_present
      end
    end

    context 'with invalid token' do
      let(:params) { { email: user.email } }
      let(:reset_token) { 'invalid' }

      it 'redirects to root url', :aggregate_failures do
        make_request
        expect(response).to redirect_to root_url
        expect(flash[:danger]).to be_present
      end
    end

    context 'with expired token' do
      let(:params) { { email: user.email } }
      let(:reset_token) { user.reset_token }

      it 'redirects to new password reset url', :aggregate_failures do
        user.update_attribute(:reset_sent_at, 3.hours.ago)
        make_request

        expect(response).to redirect_to new_password_reset_url
        expect(flash[:danger]).to be_present
      end
    end
  end

  describe 'GET /new' do
    subject! { get new_password_reset_path }

    it { expect(response).to render_template(:new) }
  end

  describe 'POST /create' do
    subject! { post password_resets_path, params: params }

    let(:user) { FactoryBot.create(:user) }

    context 'with valid email' do
      let(:params) { { password_reset: { email: user.email } } }

      it 'sends password reset email', :aggregate_failures do
        expect(user.reload.reset_digest).not_to be_nil
        expect(ActionMailer::Base.deliveries.size).to eq(1)
        expect(flash[:info]).to be_present
        expect(response).to redirect_to root_url
      end
    end

    context 'with invalid email' do
      let(:params) { { password_reset: { email: 'invalid@example.com' } } }

      it 'renders new template', :aggregate_failures do
        expect(flash[:danger]).to be_present
        expect(ActionMailer::Base.deliveries.size).to eq(0)
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET /edit' do
    subject(:make_request) { get edit_password_reset_path(reset_token), params: params }

    it_behaves_like 'password reset validations'

    context 'with valid email and token' do
      let(:user) { FactoryBot.create(:user, :pending_password_reset) }
      let(:params) { { email: user.email } }
      let(:reset_token) { user.reset_token }

      before { make_request }

      it { expect(response).to render_template(:edit) }
    end
  end

  describe 'PATCH /update' do
    subject(:make_request) { patch password_reset_path(reset_token), params: params }

    let(:user) { FactoryBot.create(:user, :pending_password_reset) }

    it_behaves_like 'password reset validations'

    context 'with valid password' do
      let(:reset_token) { user.reset_token }
      let(:params) do
        {
          email: user.email,
          user: {
            password: 'newpassword',
            password_confirmation: 'newpassword'
          }
        }
      end

      it 'updates the password', :aggregate_failures do
        make_request
        expect(user.reload.reset_digest).to be_nil
        expect(is_logged_in?(user)).to be true
        expect(flash[:success]).to be_present
        expect(response).to redirect_to user
      end
    end

    context 'with invalid password' do
      let(:reset_token) { user.reset_token }
      let(:params) do
        {
          email: user.email,
          user: {
            password: 'newpassword',
            password_confirmation: 'wrongpassword'
          }
        }
      end

      before { make_request }

      it { expect(response).to render_template(:edit) }
    end

    context 'with empty password' do
      let(:reset_token) { user.reset_token }
      let(:params) do
        {
          email: user.email,
          user: {
            password: '',
            password_confirmation: ''
          }
        }
      end

      before { make_request }

      it { expect(response).to render_template(:edit) }
    end
  end
end
