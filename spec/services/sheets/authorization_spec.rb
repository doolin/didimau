# frozen_string_literal: true

# google sheets auth spec

require 'rails_helper'

describe Sheets::Authorization do
  let(:client_id) { '1234567890' }
  let(:client_secret) { '1234567890' }
  let(:redirect_uri) { 'http://localhost:3000/auth/google/callback' }
  let(:spreadsheet_id) { ENV["DEMO_SPREADSHEET_ID"] }
  let(:sheet_name) { "Board" }
  let(:credentials_path) { ENV["GOOGLE_APPLICATION_CREDENTIALS"] }

  subject(:authorization) { Sheets::Authorization.new }

  describe '#list_google_sheets' do
    it 'returns a list of sheet names' do
      actual = authorization.list_google_sheets(spreadsheet_id, credentials_path)

      # puts "actual: #{actual}"

      expect(actual).to be_a(Array)
      expect(actual.length).to be > 0
      expect(actual.first).to be_a(String)
    end
  end

  describe '#get_spreadsheet_data' do
    it 'returns a list of sheet names' do
      actual = authorization.get_spreadsheet_data(spreadsheet_id, sheet_name, credentials_path)

      # puts "actual: #{actual.first}"

      expect(actual).to be_a(Array)
      expect(actual.length).to be > 0
      expect(actual.first).to be_a(Array)
    end
  end

  # describe '#download_spreadsheet_csv' do
  #   it 'returns a csv' do
  #     actual = authorization.download_spreadsheet_csv(ENV["DEMO_SPREADSHEET_ID"], ENV["GOOGLE_APPLICATION_CREDENTIALS"], "board.csv")
  #     expect(actual).to be_a(String)
  #   end
  # end
end
