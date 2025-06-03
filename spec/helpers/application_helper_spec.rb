# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper do
  describe '#full_title' do
    context 'when page_title is provided' do
      it 'returns page title with base title' do
        expect(helper.full_title('About')).to eq('About | Tuiter')
      end
    end

    context 'when page_title is empty' do
      it 'returns only the base title when passed empty string' do
        expect(helper.full_title('')).to eq('Tuiter')
      end

      it 'returns only the base title when no argument is passed' do
        expect(helper.full_title).to eq('Tuiter')
      end
    end
  end
end
