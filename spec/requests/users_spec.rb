# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users' do
  describe 'GET /users' do
    subject { get users_path }

    context 'when not logged in' do
      it 'redirects to login url' do
        subject

        expect(response).to redirect_to login_url
        expect(flash[:danger]).to be_present
        expect(session[:forwarding_url]).to eq users_url
      end
    end

    context 'when logged in' do
      let(:user) { FactoryBot.create(:user) }

      before do
        log_in_as(user)
      end

      it 'shows index page' do
        subject

        expect(response).to render_template(:index)
      end
    end
  end

  describe 'GET /users/:id' do
    let(:user) { FactoryBot.create(:user) }

    subject { get user_path(user) }

    context 'when not activated' do
      before { user.toggle!(:activated) }

      it 'redirects to root url' do
        subject

        expect(response).to redirect_to root_url
      end
    end

    context 'when activated' do
      it 'shows user profile' do
        subject

        expect(response).to render_template(:show)
      end
    end
  end

  describe 'GET /signup' do
    it 'renders signup page' do
      get signup_path

      expect(response).to render_template(:new)
    end
  end

  describe 'POST /users' do
    subject { post users_path, params: params }

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

      it 'creates a new user' do
        expect { subject }.to change(User, :count).by(1)

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

      it 'does not create a user' do
        expect { subject }.not_to change(User, :count)

        expect(response).to render_template(:new)
        expect(ActionMailer::Base.deliveries.size).to eq(0)
      end
    end
  end

  describe 'GET /users/:id/edit' do
    let(:user) { FactoryBot.create(:user) }

    subject { get edit_user_path(user) }

    context 'when not logged in' do
      it 'redirects to login url' do
        subject

        expect(response).to redirect_to login_url
        expect(session[:forwarding_url]).to eq edit_user_url(user)
        expect(flash[:danger]).to be_present
      end
    end

    context 'when logged in as wrong user' do
      let(:other_user) { FactoryBot.create(:user) }

      before { log_in_as(other_user) }

      it 'redirects to root url' do
        subject

        expect(response).to redirect_to root_url
      end
    end

    context 'when logged in as correct user' do
      before { log_in_as(user) }

      it 'renders edit page' do
        subject

        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'PATCH /users/:id' do
    let(:user) { FactoryBot.create(:user) }

    subject { patch user_path(user), params: params }

    context 'when not logged in' do
      let(:params) { { user: {} } }

      it 'redirects to login url' do
        subject

        expect(flash[:danger]).to be_present
        expect(response).to redirect_to login_url
      end
    end

    context 'when logged in as wrong user' do
      let(:other_user) { FactoryBot.create(:user) }
      let(:params) { { user: {} } }

      before { log_in_as(other_user) }

      it 'redirects to root url' do
        subject

        expect(flash).to be_empty
        expect(response).to redirect_to root_url
      end
    end

    context 'when logged in as correct user' do
      before { log_in_as(user) }

      context 'with valid information' do
        let(:params) { { user: { email: 'new@example.com' } } }

        it 'updates user profile' do
          subject

          expect(flash[:success]).to be_present
          expect(response).to redirect_to user
        end
      end

      context 'with invalid information' do
        let(:params) { { user: { email: ' ' } } }

        it 'renders edit page' do
          subject

          expect(response).to render_template(:edit)
        end
      end
    end
  end

  describe 'DELETE /users/:id' do
    let(:user) { FactoryBot.create(:user) }

    subject { delete user_path(user) }

    context 'when not logged in' do
      it 'redirects to login url' do
        subject

        expect(response).to redirect_to login_url
        expect(flash[:danger]).to be_present
      end
    end

    context 'when logged in as non-admin' do
      let(:non_admin) { FactoryBot.create(:user) }

      before { log_in_as(non_admin) }

      it 'redirects to root url' do
        subject

        expect(response).to redirect_to root_url
      end
    end

    context 'when logged in as admin' do
      let(:admin) { FactoryBot.create(:user, :admin) }

      before { log_in_as(admin) }

      it 'deletes the user' do
        subject

        expect(flash[:success]).to be_present
        expect(response).to redirect_to users_url
      end
    end
  end

  describe 'GET /users/:id/following' do
    let(:user) { FactoryBot.create(:user) }

    subject { get following_user_path(user) }

    context 'when not logged in' do
      it 'redirects to login url' do
        subject

        expect(response).to redirect_to login_url
        expect(flash[:danger]).to be_present
        expect(session[:forwarding_url]).to eq following_user_url(user)
      end
    end

    context 'when logged in' do
      before { log_in_as(user) }

      it 'shows following page' do
        subject

        expect(response).to render_template('users/show_follow')
      end
    end
  end

  describe 'GET /users/:id/followers' do
    let(:user) { FactoryBot.create(:user) }

    subject { get followers_user_path(user) }

    context 'when not logged in' do
      it 'redirects to login url' do
        subject

        expect(response).to redirect_to login_url
        expect(flash[:danger]).to be_present
        expect(session[:forwarding_url]).to eq followers_user_url(user)
      end
    end

    context 'when logged in' do
      before { log_in_as(user) }

      it 'shows followers page' do
        subject

        expect(response).to render_template('users/show_follow')
      end
    end
  end
end
