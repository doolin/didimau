require "google/apis/sheets_v4"
require "google/apis/drive_v3"
require "googleauth"

module Sheets
  class Authorization
    SCOPES_SHEETS = [Google::Apis::SheetsV4::AUTH_SPREADSHEETS_READONLY].freeze
    SCOPES_DRIVE = [Google::Apis::DriveV3::AUTH_DRIVE_FILE].freeze

    def initialize(credentials_path: nil)
      @credentials_path = credentials_path || Rails.root.join(ENV.fetch("GOOGLE_APPLICATION_CREDENTIALS"))
    end

    def list_google_sheets(spreadsheet_id)
      service = sheets_service
      spreadsheet = service.get_spreadsheet(spreadsheet_id)
      spreadsheet.sheets.map { |sheet| sheet.properties.title }
    end

    def get_spreadsheet_data(spreadsheet_id, sheet_name)
      service = sheets_service
      response = service.get_spreadsheet_values(spreadsheet_id, sheet_name)
      response.values
    end

    def download_spreadsheet_csv(spreadsheet_id, destination_path)
      service = drive_service
      service.get_file(spreadsheet_id, download_dest: destination_path)
    end

    private

    def sheets_service
      service = Google::Apis::SheetsV4::SheetsService.new
      service.client_options.application_name = "Didimau"
      service.authorization = authorize(SCOPES_SHEETS)
      service
    end

    def drive_service
      service = Google::Apis::DriveV3::DriveService.new
      service.client_options.application_name = "Didimau"
      service.authorization = authorize(SCOPES_DRIVE)
      service
    end

    def authorize(scopes)
      Google::Auth::ServiceAccountCredentials.make_creds(
        json_key_io: File.open(@credentials_path),
        scope: scopes
      )
    end
  end
end
