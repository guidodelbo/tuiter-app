# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Microposts' do
  describe 'POST /microposts' do
    subject { post microposts_path, params: params }

    context 'when not logged in' do
      let(:params) { { micropost: { content: 'My new cool tuit' } } }

      it 'redirects to login url' do
        expect { subject }.not_to change(Micropost, :count)
        expect(response).to redirect_to login_url
      end
    end

    context 'when logged in' do
      let(:user) { FactoryBot.create(:user) }

      before { log_in_as(user) }

      context 'with valid information' do
        let(:params) { { micropost: { content: 'My new cool tuit' } } }

        it 'creates a micropost' do
          expect { subject }.to change(Micropost, :count).by(1)
          expect(response).to redirect_to root_url
          expect(flash[:success]).to be_present
        end
      end

      context 'with invalid information' do
        let(:params) { { micropost: { content: '' } } }

        it 'does not create a micropost' do
          expect { subject }.not_to change(Micropost, :count)
          expect(response).to render_template('static_pages/home')
        end
      end
    end
  end

  describe 'DELETE /microposts/:id' do
    subject { delete micropost_path(micropost) }

    context 'when not logged in' do
      let(:micropost) { 1 }

      it 'redirects to login url' do
        expect { subject }.not_to change(Micropost, :count)
        expect(response).to redirect_to login_url
      end
    end

    context 'when logged in' do
      let(:user) { FactoryBot.create(:user) }
      let!(:micropost) { FactoryBot.create(:micropost, user: user) }

      context 'when logged as a different user' do
        let(:wrong_user) { FactoryBot.create(:user) }

        before { log_in_as(wrong_user) }

        it 'redirects to root url' do
          expect { subject }.not_to change(Micropost, :count)
          expect(response).to redirect_to root_url
        end
      end

      context 'when logged in as the user who created the micropost' do
        before { log_in_as(user) }

        it 'deletes the micropost' do
          expect { subject }.to change(Micropost, :count).by(-1)
          expect(response).to redirect_to root_url
          expect(flash[:success]).to be_present
        end
      end
    end
  end
end
