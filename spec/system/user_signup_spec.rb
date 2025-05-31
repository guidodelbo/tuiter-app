# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UserSignUp' do
  before do
    driven_by(:rack_test)
    visit signup_path
  end

  context 'with invalid information' do
    it 'shows an error message' do
      fill_in 'Name', with: ''
      fill_in 'Email', with: ''
      fill_in 'Password', with: ''
      fill_in 'Confirmation', with: ''
      click_button 'Create my account'

      expect(page).to have_css('.alert-danger')

      # TODO: add this back in when we fix the form refresh issue
      # expect(page).to have_current_path(signup_path)
    end
  end

  context 'with valid information' do
    before { ActionMailer::Base.deliveries.clear }

    it 'creates a user', :aggregate_failures do
      fill_in 'Name', with: 'Example User'
      fill_in 'Email', with: 'user@example.com'
      fill_in 'Password', with: 'password'
      fill_in 'Confirmation', with: 'password'

      expect {
        click_button 'Create my account'
      }.to change(User, :count).by(1)
       .and change { ActionMailer::Base.deliveries.count }.by(1)

      expect(page).to have_current_path(root_path)

      expect(page).to have_css('.alert-info', text: 'Please check your email to activate your account')

      user = User.last
      expect(user.name).to eq('Example User')
      expect(user.email).to eq('user@example.com')
      expect(user.activated?).to be(false)
      expect(user.activation_digest).to be_present

      email = ActionMailer::Base.deliveries.last
      expect(email.to).to include('user@example.com')
      expect(email.subject).to include('Tuiter account activation')
    end
  end
end
