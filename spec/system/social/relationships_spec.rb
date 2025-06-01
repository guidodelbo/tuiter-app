# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Relationships' do
  let(:current_user) { FactoryBot.create(:user) }
  let(:user) { FactoryBot.create(:user) }
  let(:relationship) { FactoryBot.create(:relationship) }

  before do
    driven_by(:rack_test)
    FactoryBot.create_list(:relationship, 10, follower: user)
    FactoryBot.create_list(:relationship, 3, followed: user)
  end

  describe 'following page' do
    context 'when logged in' do
      before do
        log_in_as(current_user)
        visit following_user_path(user)
      end

      it 'displays the followed users', :aggregate_failures do
        within('section.user_info') do
          expect(page).to have_content(user.name)
          expect(page).to have_link('view my profile', href: user_path(user))
          expect(page).to have_css('img.gravatar')
        end

        within('section.stats') do
          expect(page).to have_link("#{user.following.count} following", href: following_user_path(user))
          expect(page).to have_link("#{user.followers.count} followers", href: followers_user_path(user))
        end

        expect(page).to have_css('h3', text: 'Following')
        expect(page).to have_css('ul.pagination')

        expect_relationships_displayed(user.following.paginate(page: 1, per_page: 9))

        find('li.next a').click

        expect(page).to have_css('ul.users li', count: 1)
        expect_relationships_displayed(user.following.paginate(page: 2, per_page: 9))
      end
    end

    context 'when logged out' do
      before do
        visit following_user_path(user)
      end

      it_behaves_like 'an unauthenticated user trying to access a protected page'
    end
  end

  describe 'followers page' do
    context 'when logged in' do
      before do
        log_in_as(current_user)
        visit followers_user_path(user)
      end

      it 'displays the followers', :aggregate_failures do
        expect(page).to have_css('h3', text: 'Followers')
        expect(page).to have_no_css('ul.pagination')

        expect_relationships_displayed(user.followers.paginate(page: 1, per_page: 9))
      end
    end

    context 'when logged out' do
      before do
        visit followers_user_path(user)
      end

      it_behaves_like 'an unauthenticated user trying to access a protected page'
    end  end

  private

  def expect_relationships_displayed(relationship_list)
    relationship_list.each do |relationship|
      within('div.user_avatars') do
        expect(page).to have_link(relationship.name, href: user_path(relationship))
        expect(page).to have_css('a img.gravatar')
      end

      within('ul.users.follow') do
        expect(page).to have_css('img.gravatar')
        expect(page).to have_link(relationship.name, href: user_path(relationship))
      end
    end
  end
end
