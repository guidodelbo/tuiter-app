# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'StaticPages' do
  shared_examples 'renders page' do |path, title, template = nil|
    it "renders #{title.downcase} page", :aggregate_failures do
      get send("#{path}_path")

      expect(response).to render_template(template || path)
      expect(response.body).to include(full_title(title))
    end
  end

  describe 'GET /' do
    it_behaves_like 'renders page', :root, 'Home', :home
  end

  describe 'GET /help' do
    it_behaves_like 'renders page', :help, 'Help'
  end

  describe 'GET /about' do
    it_behaves_like 'renders page', :about, 'About'
  end

  describe 'GET /contact' do
    it_behaves_like 'renders page', :contact, 'Contact'
  end
end
