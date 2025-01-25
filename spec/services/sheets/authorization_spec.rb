# frozen_string_literal: true

# google sheets auth spec

require 'rails_helper'

describe Sheets::Authorization do
  let(:client_id) { '1234567890' }
  let(:client_secret) { '1234567890' }
  let(:redirect_uri) { 'http://localhost:3000/auth/google/callback' }

  subject(:authorization) { Sheets::Authorization.new }

  describe '#list_google_sheets' do
    it 'returns a list of sheet names' do
      actual = authorization.list_google_sheets(ENV["DEMO_SPREADSHEET_ID"], ENV["GOOGLE_APPLICATION_CREDENTIALS"])

      puts "actual: #{actual}"

      expect(actual).to be_a(Array)
      expect(actual.length).to be > 0
      expect(actual.first).to be_a(String)
    end
  end
end
