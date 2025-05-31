# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UserLogin' do
  let!(:user) { FactoryBot.create(:user, email: 'user@example.com') }

  before do
    driven_by(:rack_test)
    visit login_path
  end

  context 'with invalid information' do
    it 'shows error message', :aggregate_failures do
      fill_in 'Email', with: ''
      fill_in 'Password', with: ''
      click_button 'Log in'

      expect(page).to have_css('.alert-danger')
      expect(page).to have_current_path(login_path)
    end
  end

  context 'with valid information' do
    it 'logs in and out successfully', :aggregate_failures do
      fill_in 'Email', with: 'user@example.com'
      fill_in 'Password', with: 'password'
      click_button 'Log in'

      expect(page).to have_current_path(user_path(user))
      expect(page).to have_link('Log out', href: logout_path)
      expect(page).to have_link('Profile', href: user_path(user))
      expect(page).to have_no_link('Log in', href: login_path)

      click_link 'Log out'
      expect(page).to have_current_path(root_path)
      expect(page).to have_link('Log in', href: login_path)
    end
  end

  context 'when remember me is checked' do
    it 'remembers the user' do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: 'password'
      check 'Remember me'
      click_button 'Log in'

      expect(page.driver.browser.rack_mock_session.cookie_jar['remember_token']).not_to be_nil
    end
  end
end
