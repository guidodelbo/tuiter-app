# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Feed' do
  include ActionView::Helpers::DateHelper

  before do
    driven_by(:rack_test)
  end

  context 'when logged in' do
    let(:current_user) { FactoryBot.create(:user) }
    let(:other_user) { FactoryBot.create(:user) }

    before do
      FactoryBot.create_list(:micropost, 10, user: current_user)
      FactoryBot.create_list(:micropost, 10, user: other_user)
      FactoryBot.create_list(:micropost, 10)

      current_user.follow(other_user)
      log_in_as(current_user)
      visit root_path
    end

    it 'displays feed microposts', :aggregate_failures do
      within('.navbar-nav') do
        expect(page).to have_css('li', count: 8)
        expect(page).to have_link('Home', href: root_path)
        expect(page).to have_link('Help', href: help_path)
        expect(page).to have_link('Users', href: users_path)
        expect(page).to have_link('Profile', href: user_path(current_user))
        expect(page).to have_link('Settings', href: edit_user_path(current_user))
        expect(page).to have_link('Log out', href: logout_path)
      end

      within('section.user_info') do
        expect(page).to have_content(current_user.name)
        expect(page).to have_css("a[href='/users/#{current_user.id}'] img.gravatar")
        expect(page).to have_content("#{current_user.microposts.count} tuits")
      end

      within('section.stats') do
        expect(page).to have_link("#{current_user.following.count} following", href: following_user_path(current_user))
        expect(page).to have_link("#{current_user.followers.count} followers", href: followers_user_path(current_user))
      end

      within('section.micropost_form') do
        expect(page).to have_css('form[action="/microposts"][method="post"]')
        expect(page).to have_css('textarea[name="micropost[content]"][placeholder="Compose new tuit..."]')
        expect(page).to have_field('micropost[image]', type: 'file')
        expect(page).to have_css('input[type="submit"][value="Post"]')
      end

      # only show own and followed users' microposts
      within('ol.microposts') do
        expect(page).to have_css('li', count: 20)
      end

      current_user.microposts.each do |micropost|
        expect_micropost_displayed(micropost, current_user)
      end

      other_user.microposts.each do |micropost|
        expect_micropost_displayed(micropost, current_user)
      end

      # create more microposts to test pagination
      2.times { FactoryBot.create_list(:micropost, 10, user: other_user) }

      visit root_path

      expect(page).to have_css('ul.pagination')

      first('li.next a').click

      # only the rest of the microposts are displayed
      within('ol.microposts') do
        expect(page).to have_css('li', count: 10)
      end
    end
  end

  context 'when logged out' do
    before do
      visit root_path
    end

    it 'renders the logged out home page', :aggregate_failures do
      expect(page).to have_content('Welcome to Tuiter')

      within('.jumbotron') do
        expect(page).to have_link('Sign up now!', href: signup_path)
      end

      within('.navbar-nav') do
        expect(page).to have_css('li', count: 3)
        expect(page).to have_link('Home', href: root_path)
        expect(page).to have_link('Help', href: help_path)
        expect(page).to have_link('Log in', href: login_path)
      end
    end
  end

  private

  def expect_micropost_displayed(micropost, current_user)
    within("#micropost-#{micropost.id}") do
      expect(page).to have_content(micropost.content)
      expect(page).to have_css("a[href='/users/#{micropost.user.id}'] img.gravatar")
      expect(page).to have_link(micropost.user.name, href: user_path(micropost.user))
      expect(page).to have_content("Posted #{time_ago_in_words(micropost.created_at)} ago.")

      if micropost.user == current_user
        expect(page).to have_css("a[href='#{micropost_path(micropost)}'][data-method='delete']", text: 'delete')
      end
    end
  end
end
