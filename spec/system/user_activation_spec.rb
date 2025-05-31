# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UserActivation' do
  let(:user) { FactoryBot.create(:user, :pending_activation) }

  before do
    driven_by(:rack_test)
  end

  context 'with valid information' do
    before { travel_to(Time.zone.local(2025, 1, 1, 12, 0, 0)) }

    after { travel_back }

    it 'activates the user account', :aggregate_failures do
      expect(user.activated?).to be(false)

      visit edit_account_activation_path(user.activation_token, email: user.email)

      expect(page).to have_current_path(user_path(user))
      expect(page).to have_css('.alert-success', text: 'Account activated!')

      user.reload
      expect(user.activated?).to be(true)
      expect(user.activated_at).to eq(Time.current)
    end
  end

  context 'with invalid information' do
    it 'does not activate the user', :aggregate_failures do
      expect(user.activated?).to be(false)

      visit edit_account_activation_path('invalid_token', email: user.email)

      expect(page).to have_current_path(root_path)
      expect(page).to have_css('.alert-danger', text: 'Invalid activation link')

      user.reload
      expect(user.activated?).to be(false)
    end
  end
end
