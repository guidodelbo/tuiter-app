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

      it 'redirects to root url' do
        subject

        expect(response).to redirect_to root_url
        expect(flash[:danger]).to be_present
      end
    end

    context 'with inactive user' do
      let(:params) { { email: user.email } }
      let(:reset_token) { user.reset_token }

      it 'redirects to root url' do
        user.toggle!(:activated)
        subject

        expect(response).to redirect_to root_url
        expect(flash[:danger]).to be_present
      end
    end

    context 'with invalid token' do
      let(:params) { { email: user.email } }
      let(:reset_token) { 'invalid' }

      it 'redirects to root url' do
        subject

        expect(response).to redirect_to root_url
        expect(flash[:danger]).to be_present
      end
    end

    context 'with expired token' do
      let(:params) { { email: user.email } }
      let(:reset_token) { user.reset_token }

      it 'redirects to new password reset url' do
        user.update_attribute(:reset_sent_at, 3.hours.ago)
        subject

        expect(response).to redirect_to new_password_reset_url
        expect(flash[:danger]).to be_present
      end
    end
  end

  describe 'GET /new' do
    it 'renders the new template' do
      get new_password_reset_path
      expect(response).to render_template(:new)
    end
  end

  describe 'POST /create' do
    let(:user) { FactoryBot.create(:user) }

    subject { post password_resets_path, params: params }

    context 'with valid email' do
      let(:params) { { password_reset: { email: user.email } } }

      it 'sends password reset email' do
        subject

        expect(user.reload.reset_digest).not_to be_nil
        expect(ActionMailer::Base.deliveries.size).to eq(1)
        expect(flash[:info]).to be_present
        expect(response).to redirect_to root_url
      end
    end

    context 'with invalid email' do
      let(:params) { { password_reset: { email: 'invalid@example.com' } } }

      it 'renders new template' do
        subject

        expect(flash[:danger]).to be_present
        expect(ActionMailer::Base.deliveries.size).to eq(0)
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET /edit' do
    subject { get edit_password_reset_path(reset_token), params: params }

    include_examples 'password reset validations'

    context 'with valid email and token' do
      let(:params) { { email: user.email } }
      let(:reset_token) { user.reset_token }

      it 'renders edit template' do
        subject
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'PATCH /update' do
    subject { patch password_reset_path(reset_token), params: params }

    include_examples 'password reset validations'

    let(:user) { FactoryBot.create(:user, :pending_password_reset) }

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

      it 'updates the password' do
        subject

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

      it 'renders edit template' do
        subject

        expect(response).to render_template(:edit)
      end
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

      it 'renders edit template with error message' do
        subject

        expect(response).to render_template(:edit)
      end
    end
  end
end
