# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UsersIndex' do
  before { driven_by(:rack_test) }

  context 'when visiting the users index page' do
    before { FactoryBot.create_list(:user, 10) }

    context 'when logged in as an admin' do
      before do
        FactoryBot.create(:user, :pending_activation, name: 'User Pending Activation')
        admin = FactoryBot.create(:user, :admin, name: 'Admin User')
        log_in_as(admin)
        visit users_path
      end

      it 'shows paginated users and deletes users', :aggregate_failures do
        within('ul.users') do
          self_in_current_page = page.has_content?('Admin User')

          expect(page).to have_css('li', count: 9)
          expect(page).to have_css('img.gravatar', count: 9)
          expect(page).to have_css('a', text: 'delete', count: self_in_current_page ? 8 : 9)
          expect(page).to have_no_content('User Pending Activation')
        end

        expect(page).to have_css('ul.pagination', count: 2)

        first('li.next a').click

        within('ul.users') do
          self_in_current_page = page.has_content?('Admin User')

          expect(page).to have_css('li', count: 2)
          expect(page).to have_css('img.gravatar', count: 2)
          expect(page).to have_css('a', text: 'delete', count: self_in_current_page ? 1 : 2)
          expect(page).to have_no_content('User Pending Activation')
        end

        expect(page).to have_css('ul.pagination', count: 2)

        expect {
          first('a.user-delete').click
        }.to change(User, :count).by(-1)
      end
    end

    context 'when logged in as a non-admin' do
      before do
        non_admin = FactoryBot.create(:user)
        log_in_as(non_admin)
        visit users_path
      end

      it 'shows paginated users', :aggregate_failures do
        within('ul.users') do
          expect(page).to have_css('li', count: 9)
          expect(page).to have_css('img.gravatar', count: 9)
          expect(page).to have_css('a', text: 'delete', count: 0)
        end

        expect(page).to have_css('ul.pagination', count: 2)
      end
    end
  end
end
