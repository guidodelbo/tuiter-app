# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'StaticPages' do
  shared_examples 'renders page' do |path, title, template = nil|
    it "renders #{title.downcase} page" do
      get send("#{path}_path")

      expect(response).to render_template(template || path)
      expect(response.body).to include(full_title(title))
    end
  end

  describe 'GET /' do
    include_examples 'renders page', :root, 'Home', :home
  end

  describe 'GET /help' do
    include_examples 'renders page', :help, 'Help'
  end

  describe 'GET /about' do
    include_examples 'renders page', :about, 'About'
  end

  describe 'GET /contact' do
    include_examples 'renders page', :contact, 'Contact'
  end
end
