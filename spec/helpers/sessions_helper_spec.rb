# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionsHelper do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }

  describe '#log_in' do
    before { helper.log_in(user) }

    it 'sets the user_id and session_token in the session', :aggregate_failures do
      expect(session[:user_id]).to eq(user.id)
      expect(session[:session_token]).to eq(user.session_token)
    end
  end

  describe '#remember' do
    before { helper.remember(user) }

    it 'sets permanent cookies', :aggregate_failures do
      expect(cookies.permanent.encrypted[:user_id]).to eq(user.id)
      expect(cookies.permanent[:remember_token]).to eq(user.remember_token)
    end
  end

  describe '#log_out' do
    before do
      helper.log_in(user)
      helper.log_out
    end

    it 'clears the session and cookies', :aggregate_failures do
      expect(user.reload.remember_digest).to be_nil
      expect(cookies.permanent.encrypted[:user_id]).to be_nil
      expect(cookies.permanent[:remember_token]).to be_nil
      expect(session[:user_id]).to be_nil
      expect(session[:session_token]).to be_nil
    end
  end

  describe '#current_user' do
    context 'when user is logged in via session' do
      before do
        helper.log_in(user)
      end

      it 'returns the current user' do
        expect(helper.current_user).to eq(user)
      end
    end

    context 'when session token does not match' do
      before do
        session[:session_token] = 'invalid_token'
      end

      it 'returns nil when session token is invalid' do
        expect(helper.current_user).to be_nil
      end
    end

    context 'when user is deleted' do
      before do
        user.destroy
      end

      it 'returns nil when user no longer exists' do
        expect(helper.current_user).to be_nil
      end
    end

    context 'when user is remembered via cookies' do
      before do
        helper.remember(user)
      end

      it 'returns the current user from cookies and logs in the user', :aggregate_failures do
        expect(helper.current_user).to eq(user)
        expect(session[:user_id]).to eq(user.id)
        expect(session[:session_token]).to eq(user.session_token)
      end
    end

    context 'when remember token does not match' do
      before do
        helper.remember(user)
        cookies[:remember_token] = 'invalid_token'
      end

      it { expect(helper.current_user).to be_nil }
    end

    context 'when user is not found' do
      before do
        helper.remember(user)
        user.destroy
      end

      it { expect(helper.current_user).to be_nil }
    end

    context 'when no user is logged in or remembered' do
      it { expect(helper.current_user).to be_nil }
    end
  end

  describe '#current_user?' do
    before do
      helper.log_in(user)
    end

    it 'returns true when the given user is the current user' do
      expect(helper.current_user?(user)).to be true
    end

    it 'returns false when the given user is not the current user' do
      expect(helper.current_user?(other_user)).to be false
    end

    it 'returns false when given user is nil' do
      expect(helper.current_user?(nil)).to be false
    end

    context 'when no user is logged in' do
      before do
        helper.log_out
      end

      it 'returns false even when comparing with a valid user' do
        expect(helper.current_user?(user)).to be false
      end
    end
  end
end
