# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UserShow' do
  let(:current_user) { FactoryBot.create(:user) }
  let(:user) { FactoryBot.create(:user) }

  before do
    driven_by(:rack_test)
  end

  context 'when logged in' do
    before do
      log_in_as(current_user)
    end

    context 'when the user has microposts' do
      before do
        FactoryBot.create_list(:micropost, 3, user: user)
        visit user_path(user)
      end

      it_behaves_like 'a user profile with information and microposts'

      it 'displays the follow form' do
        expect(page).to have_css('#follow_form')
      end
    end

    context 'when the user has no microposts' do
      before do
        visit user_path(user)
      end

      it 'does not display the microposts', :aggregate_failures do
        expect(page).to have_no_css('h3', text: 'Tuits')
        expect(page).to have_no_css('ol.microposts')
      end
    end

    context 'when following another user' do
      before do
        visit user_path(user)
      end

      it 'increments the following count', :aggregate_failures do
        expect {
          click_button 'Follow'
        }.to change { current_user.following.count }.by(1)

        expect(page).to have_css('#follow_form')
      end
    end
  end

  context 'when not logged in' do
    before do
      FactoryBot.create_list(:micropost, 3, user: user)
      visit user_path(user)
    end

    it_behaves_like 'a user profile with information and microposts'

    it 'does not display the follow form' do
      expect(page).to have_no_css('#follow_form')
    end
  end
end
