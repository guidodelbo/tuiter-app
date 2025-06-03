# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users' do
  describe 'GET /users' do
    subject(:get_users) { get users_path }

    context 'when not logged in' do
      before { get_users }

      it 'redirects to login url', :aggregate_failures do
        expect(response).to redirect_to login_url
        expect(flash[:danger]).to be_present
        expect(session[:forwarding_url]).to eq users_url
      end
    end

    context 'when logged in' do
      let(:user) { FactoryBot.create(:user) }

      before do
        log_in_as(user)
        get_users
      end

      it { expect(response).to render_template(:index) }
    end
  end

  describe 'GET /users/:id' do
    subject(:get_user) { get user_path(user) }

    let(:user) { FactoryBot.create(:user) }


    context 'when not activated' do
      before do
        user.toggle!(:activated)
        get_user
      end

      it { expect(response).to redirect_to root_url }
    end

    context 'when activated' do
      before { get_user }

      it { expect(response).to render_template(:show) }
    end
  end

  describe 'GET /signup' do
    subject! { get signup_path }

    it { expect(response).to render_template(:new) }
  end

  describe 'POST /users' do
    subject(:post_user) { post users_path, params: params }

    context 'with valid information' do
      let(:params) do
        {
          user: {
            name: 'Example User',
            email: 'user@example.com',
            password: 'password',
            password_confirmation: 'password'
          }
        }
      end

      it 'creates a new user', :aggregate_failures do
        expect { post_user }.to change(User, :count).by(1)
        expect(response).to redirect_to root_url
        expect(flash[:info]).to be_present
        expect(ActionMailer::Base.deliveries.size).to eq(1)
      end
    end

    context 'with invalid information' do
      let(:params) do
        {
          user: {
            name: '',
            email: 'user@invalid',
            password: 'foo',
            password_confirmation: 'bar'
          }
        }
      end

      it 'does not create a user', :aggregate_failures do
        expect { post_user }.not_to change(User, :count)
        expect(response).to render_template(:new)
        expect(ActionMailer::Base.deliveries.size).to eq(0)
      end
    end
  end

  describe 'GET /users/:id/edit' do
    subject(:get_edit_user) { get edit_user_path(user) }

    let(:user) { FactoryBot.create(:user) }


    context 'when not logged in' do
      before { get_edit_user }

      it 'redirects to login url', :aggregate_failures do
        expect(response).to redirect_to login_url
        expect(session[:forwarding_url]).to eq edit_user_url(user)
        expect(flash[:danger]).to be_present
      end
    end

    context 'when logged in as wrong user' do
      let(:other_user) { FactoryBot.create(:user) }

      before do
        log_in_as(other_user)
        get_edit_user
      end

      it { expect(response).to redirect_to root_url }
    end

    context 'when logged in as correct user' do
      before do
        log_in_as(user)
        get_edit_user
      end

      it { expect(response).to render_template(:edit) }
    end
  end

  describe 'PATCH /users/:id' do
    subject(:patch_user) { patch user_path(user), params: params }

    let(:user) { FactoryBot.create(:user) }


    context 'when not logged in' do
      let(:params) { { user: {} } }

      before { patch_user }

      it 'redirects to login url', :aggregate_failures do
        expect(flash[:danger]).to be_present
        expect(response).to redirect_to login_url
      end
    end

    context 'when logged in as wrong user' do
      let(:other_user) { FactoryBot.create(:user) }
      let(:params) { { user: {} } }

      before do
        log_in_as(other_user)
        patch_user
      end

      it 'redirects to root url', :aggregate_failures do
        expect(flash).to be_empty
        expect(response).to redirect_to root_url
      end
    end

    context 'when logged in as correct user with valid information' do
      let(:params) { { user: { email: 'new@example.com' } } }

      before do
        log_in_as(user)
        patch_user
      end

      it 'updates user profile', :aggregate_failures do
        expect(flash[:success]).to be_present
        expect(response).to redirect_to user
      end
    end

    context 'when logged in as correct user with invalid information' do
      let(:params) { { user: { email: ' ' } } }

      before do
        log_in_as(user)
        patch_user
      end

      it { expect(response).to render_template(:edit) }
    end
  end

  describe 'DELETE /users/:id' do
    subject(:delete_user) { delete user_path(user) }

    let(:user) { FactoryBot.create(:user) }


    context 'when not logged in' do
      before { delete_user }

      it 'redirects to login url', :aggregate_failures do
        expect(response).to redirect_to login_url
        expect(flash[:danger]).to be_present
      end
    end

    context 'when logged in as non-admin' do
      let(:non_admin) { FactoryBot.create(:user) }

      before do
        log_in_as(non_admin)
        delete_user
      end

      it { expect(response).to redirect_to root_url }
    end

    context 'when logged in as admin' do
      let(:admin) { FactoryBot.create(:user, :admin) }

      before do
        log_in_as(admin)
        delete_user
      end

      it 'deletes the user', :aggregate_failures do
        expect(flash[:success]).to be_present
        expect(response).to redirect_to users_url
      end
    end
  end

  describe 'GET /users/:id/following' do
    subject(:get_following_user) { get following_user_path(user) }

    let(:user) { FactoryBot.create(:user) }

    context 'when not logged in' do
      before { get_following_user }

      it 'redirects to login url', :aggregate_failures do
        expect(response).to redirect_to login_url
        expect(flash[:danger]).to be_present
        expect(session[:forwarding_url]).to eq following_user_url(user)
      end
    end

    context 'when logged in' do
      before do
        log_in_as(user)
        get_following_user
      end

      it { expect(response).to render_template('users/show_follow') }
    end
  end

  describe 'GET /users/:id/followers' do
    subject(:get_followers_user) { get followers_user_path(user) }

    let(:user) { FactoryBot.create(:user) }

    context 'when not logged in' do
      before { get_followers_user }

      it 'redirects to login url', :aggregate_failures do
        expect(response).to redirect_to login_url
        expect(flash[:danger]).to be_present
        expect(session[:forwarding_url]).to eq followers_user_url(user)
      end
    end

    context 'when logged in' do
      before do
        log_in_as(user)
        get_followers_user
      end

      it { expect(response).to render_template('users/show_follow') }
    end
  end
end
