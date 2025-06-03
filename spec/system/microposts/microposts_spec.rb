# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Microposts' do
  let(:user) { FactoryBot.create(:user) }

  before do
    driven_by(:rack_test)

    FactoryBot.create_list(:micropost, 4, user: user)
    log_in_as(user)
    visit root_path
  end

  describe 'creating microposts' do
    context 'with valid content' do
      it 'creates a micropost', :aggregate_failures do
        expect {
          fill_in 'micropost_content', with: 'my cool tuit'
          click_button 'Post'
        }.to change(Micropost, :count).by(1)

        expect(page).to have_current_path(root_path)

        within('ol.microposts li:first-child') do
          expect(page).to have_content('my cool tuit')
          expect(page).to have_content('Posted less than a minute ago.')
          expect(page).to have_no_css('.content img')
        end
      end

      it 'creates a micropost with image', :aggregate_failures do
        expect {
          fill_in 'micropost_content', with: 'my cool tuit with image'
          attach_file 'micropost_image', Rails.root.join('spec', 'fixtures', 'files', 'kitten.jpg')
          click_button 'Post'
        }.to change(Micropost, :count).by(1)

        within('ol.microposts li:first-child') do
          expect(page).to have_content('my cool tuit with image')
          expect(page).to have_content('Posted less than a minute ago.')
          expect(page).to have_css('.content img')
        end
      end
    end

    context 'with invalid content' do
      it 'shows validation errors for empty content', :aggregate_failures do
        expect {
          fill_in 'micropost_content', with: ''
          click_button 'Post'
        }.not_to change(Micropost, :count)

        expect(page).to have_css('div#error_explanation', text: "Content can't be blank")
      end
    end
  end

  describe 'deleting microposts' do
    it 'deletes own micropost', :aggregate_failures do
      micropost = user.microposts.last

      expect {
        within("li#micropost-#{micropost.id}") do
          click_link 'delete'
        end
      }.to change(Micropost, :count).by(-1)

      expect(page).to have_current_path(root_path)
      expect(page).to have_no_css("li#micropost-#{micropost.id}")
    end
  end
end
