# frozen_string_literal: true

# google sheets auth spec

require 'rails_helper'

describe Sheets::Authorization do
  let(:client_id) { '1234567890' }
  let(:client_secret) { '1234567890' }
  let(:redirect_uri) { 'http://localhost:3000/auth/google/callback' }

  subject { Sheets::Authorization.new(client_id, client_secret, redirect_uri) }

  describe '#get_auth_url' do
    it 'returns the correct auth url' do
      expect(subject.get_auth_url).to eq("https://accounts.google.com/o/oauth2/auth?client_id=#{client_id}&redirect_uri=#{redirect_uri}&response_type=code&scope=https://www.googleapis.com/auth/spreadsheets")
    end
  end
end
