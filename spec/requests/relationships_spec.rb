# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Relationships' do
  describe 'POST /relationships' do
    subject { post relationships_path, params: params }

    context 'when not logged in' do
      let(:params) { { followed_id: 1 } }

      it 'redirects to login url' do
        expect { subject }.not_to change(Relationship, :count)
        expect(response).to redirect_to login_url
      end
    end

    context 'when logged in' do
      let(:user) { FactoryBot.create(:user) }
      let(:other_user) { FactoryBot.create(:user) }
      let(:params) { { followed_id: other_user.id } }

      before { log_in_as(user) }

      it 'creates a relationship' do
        expect { subject }.to change(Relationship, :count).by(1)
      end

      it 'creates a relationship with Ajax' do
        expect { post relationships_path, params: params, xhr: true }.to change(Relationship, :count).by(1)
      end
    end
  end

  describe 'DELETE /relationships/:id' do
    subject { delete relationship_path(relationship) }

    context 'when not logged in' do
      let(:relationship) { 1 }

      it 'redirects to login url' do
        expect { subject }.not_to change(Relationship, :count)
        expect(response).to redirect_to login_url
      end
    end

    context 'when logged in' do
      let(:user) { FactoryBot.create(:user) }
      let(:other_user) { FactoryBot.create(:user) }
      let!(:relationship) { user.active_relationships.create!(followed_id: other_user.id) }

      before { log_in_as(user) }

      it 'destroys a relationship' do
        expect { subject }.to change(Relationship, :count).by(-1)
        expect(response).to redirect_to other_user
      end

      it 'destroys a relationship with Ajax' do
        expect {
          delete relationship_path(relationship), xhr: true
        }.to change(Relationship, :count).by(-1)
      end
    end
  end
end
