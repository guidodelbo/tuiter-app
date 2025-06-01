# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UserEdit' do
  let(:user) { FactoryBot.create(:user) }

  before do
    driven_by(:rack_test)
  end

  context 'when logged in' do
    before do
      log_in_as(user)
      visit edit_user_path(user)
    end

    context 'with valid information' do
      it 'updates the user', :aggregate_failures do
        fill_in 'Password', with: 'newpassword'
        fill_in 'Confirmation', with: 'newpassword'

        expect {
          click_button 'Save changes'
        }.to change { user.reload.password_digest }

        within('.alert-success') do
          expect(page).to have_content('Profile updated')
        end

        expect(page).to have_current_path(user_path(user))
        expect(user.reload).to be_authenticated(:password, 'newpassword')
      end
    end

    context 'with invalid information' do
      it 'does not update the user', :aggregate_failures do
        fill_in 'Email', with: ''

        expect {
          click_button 'Save changes'
        }.not_to change(user.reload, :email)

        within('#error_explanation') do
          expect(page).to have_content('Email can\'t be blank')
        end

        # TODO: add this back when we fix the form refresh issue
        # expect(page).to have_current_path(edit_user_path(user))
      end
    end
  end

  context 'when not logged in' do
    before do
      visit edit_user_path(user)
    end

    it_behaves_like 'an unauthenticated user trying to access a protected page'
  end
end
