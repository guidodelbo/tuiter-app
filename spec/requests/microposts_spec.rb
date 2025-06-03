# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Microposts' do
  describe 'POST /microposts' do
    subject(:post_micropost) { post microposts_path, params: params }

    let(:user) { FactoryBot.create(:user) }

    context 'when not logged in' do
      let(:params) { { micropost: { content: 'My new cool tuit' } } }

      it 'redirects to login url', :aggregate_failures do
        expect { post_micropost }.not_to change(Micropost, :count)
        expect(response).to redirect_to login_url
      end
    end

    context 'with valid information' do
      let(:params) { { micropost: { content: 'My new cool tuit' } } }

      before { log_in_as(user) }

      it 'creates a micropost', :aggregate_failures do
        expect { post_micropost }.to change(Micropost, :count).by(1)
        expect(response).to redirect_to root_url
        expect(flash[:success]).to be_present
      end
    end

    context 'with invalid information' do
      let(:params) { { micropost: { content: '' } } }

      before { log_in_as(user) }

      it 'does not create a micropost', :aggregate_failures do
        expect { post_micropost }.not_to change(Micropost, :count)
        expect(response).to render_template('static_pages/home')
      end
    end
  end

  describe 'DELETE /microposts/:id' do
    subject(:delete_micropost) { delete micropost_path(micropost_id) }

    let(:user) { FactoryBot.create(:user) }

    before { FactoryBot.create(:micropost, user: user, id: 9) }

    context 'when not logged in' do
      let(:micropost_id) { 1 }

      it 'redirects to login url', :aggregate_failures do
        expect { delete_micropost }.not_to change(Micropost, :count)
        expect(response).to redirect_to login_url
      end
    end

    context 'when logged as a different user' do
      let(:micropost_id) { 9 }
      let(:wrong_user) { FactoryBot.create(:user) }

      before { log_in_as(wrong_user) }

      it 'redirects to root url', :aggregate_failures do
        expect { delete_micropost }.not_to change(Micropost, :count)
        expect(response).to redirect_to root_url
      end
    end

    context 'when logged in as the user who created the micropost' do
      let(:micropost_id) { 9 }

      before { log_in_as(user) }

      it 'deletes the micropost', :aggregate_failures do
        expect { delete_micropost }.to change(Micropost, :count).by(-1)
        expect(response).to redirect_to root_url
        expect(flash[:success]).to be_present
      end
    end
  end
end
