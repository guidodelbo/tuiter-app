# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UserPasswordReset' do
  before do
    driven_by(:rack_test)
    ActionMailer::Base.deliveries.clear
    travel_to(Time.zone.local(2025, 1, 1, 12, 0, 0))
  end

  after { travel_back }

  context 'when requesting a password reset' do
    let!(:user) { FactoryBot.create(:user, email: 'user@example.com') }

    context 'with a valid email' do
      it 'sends a password reset email', :aggregate_failures do
        visit login_path
        click_link '(forgot password)'

        expect(page).to have_current_path(new_password_reset_path)

        within('#password-reset-form') do
          expect(page).to have_field('Email')
          expect(page).to have_button('Submit')

          fill_in 'Email', with: 'user@example.com'

          expect {
            click_button 'Submit'
          }.to change { ActionMailer::Base.deliveries.count }.by(1)
        end

        expect(page).to have_css('.alert-info', text: 'Email with password reset instructions was sent')
        expect(page).to have_current_path(root_path)

        expect(ActionMailer::Base.deliveries.last.to).to eq([ 'user@example.com' ])
        expect(ActionMailer::Base.deliveries.last.subject).to include('Tuiter password reset')

        expect(user.reset_digest).not_to eq(user.reload.reset_digest)
        expect(user.reload.reset_sent_at).to eq(Time.current)
      end
    end

    context 'with an invalid email' do
      it 'shows an error message', :aggregate_failures do
        visit new_password_reset_path
        fill_in 'Email', with: 'invalid@example.com'

        expect {
          click_button 'Submit'
        }.not_to change { ActionMailer::Base.deliveries.count }

        expect(page).to have_css('.alert-danger', text: 'Email address was not found')

        # TODO: add this back in when we fix the form refresh issue
        # expect(page).to have_current_path(new_password_reset_path)
      end
    end
  end

  context 'when visiting the password reset page' do
    let!(:user) { FactoryBot.create(:user, :pending_password_reset, email: 'user@example.com') }

    context 'with valid information' do
      it 'resets the password correctly', :aggregate_failures do
        visit edit_password_reset_path(user.reset_token, email: user.email)

        within('#password-reset-form') do
          expect(page).to have_field('Password')
          expect(page).to have_field('Confirmation')
          expect(page).to have_button('Update password')

          fill_in 'Password', with: 'newpassword'
          fill_in 'Confirmation', with: 'newpassword'
          click_button 'Update password'
        end

        expect(page).to have_css('.alert-success', text: 'Password has been reset')
        expect(page).to have_current_path(user_path(user))

        expect(user.reload.reset_digest).to be_nil
      end
    end

      context 'with an expired token' do
        before { user.update(reset_sent_at: 3.hours.ago) }

        it 'shows an error message', :aggregate_failures do
          visit edit_password_reset_path(user.reset_token, email: user.email)

          expect(page).to have_css('.alert-danger', text: 'Password reset has expired')
          expect(page).to have_current_path(new_password_reset_path)
        end
      end

      context 'with an invalid token' do
        it 'shows an error message', :aggregate_failures do
          visit edit_password_reset_path('invalid_token', email: user.email)

          expect(page).to have_css('.alert-danger', text: 'Wrong password reset link')
          expect(page).to have_current_path(root_path)
        end
      end
  end
end
