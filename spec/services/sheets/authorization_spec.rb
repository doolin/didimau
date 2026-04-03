# frozen_string_literal: true

require 'rails_helper'

describe Sheets::Authorization, if: ENV["GOOGLE_APPLICATION_CREDENTIALS"].present? do
  let(:spreadsheet_id) { ENV["DEMO_SPREADSHEET_ID"] }
  let(:sheet_name) { "Board" }
  let(:credentials_path) { ENV["GOOGLE_APPLICATION_CREDENTIALS"] }

  subject(:authorization) { Sheets::Authorization.new(credentials_path: credentials_path) }

  describe '#list_google_sheets' do
    it 'returns a list of sheet names' do
      actual = authorization.list_google_sheets(spreadsheet_id)

      expect(actual).to be_a(Array)
      expect(actual.length).to be > 0
      expect(actual.first).to be_a(String)
    end
  end

  describe '#get_spreadsheet_data' do
    it 'returns spreadsheet data as nested arrays' do
      actual = authorization.get_spreadsheet_data(spreadsheet_id, sheet_name)

      expect(actual).to be_a(Array)
      expect(actual.length).to be > 0
      expect(actual.first).to be_a(Array)
    end
  end

  # describe '#download_spreadsheet_csv' do
  #   it 'downloads a csv file' do
  #     actual = authorization.download_spreadsheet_csv(spreadsheet_id, "board.csv")
  #     expect(actual).to be_truthy
  #   end
  # end
end
