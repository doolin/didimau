
require "google/apis/sheets_v4"
require "google/apis/drive_v3"
require "googleauth"
require "googleauth/stores/file_token_store"

module Sheets
  class Authorization
    BASE_AUTH_URL="https://accounts.google.com/o/oauth2/auth"
    BASE_TOKEN_URL="https://oauth2.googleapis.com/token"

    CREDENTIALS_PATH = Rails.root.join(ENV["GOOGLE_APPLICATION_CREDENTIALS"])
    CREDENTIALS_JSON = File.read(CREDENTIALS_PATH)

    # The credentials have the following structure:
    # {
    #    "type": "service_account",
    #    "project_id": "xxxx",
    #    "private_key_id": "xxxx",
    #    "private_key": "xxx`",
    #    "client_email": "demoaccount@aerobic-cyclist-440800-v0.iam.gserviceaccount.com",
    #    "client_id": "xxxx",
    #    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    #    "token_uri": "https://oauth2.googleapis.com/token",
    #    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    #    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/demoaccount%40aerobic-cyclist-440800-v0.iam.gserviceaccount.com",
    #    "universe_domain": "googleapis.com"
    #  }
    #

    # We want to initial using the credentials from the .env file.
    # Note: theee is not "client_secrent" key, and the credentials can be passed as-is.
    def initialize
    end


    def list_google_sheets(spreadsheet_id, credentials_path)
      # Initialize the Sheets API client
      service = Google::Apis::SheetsV4::SheetsService.new
      service.client_options.application_name = "Google Sheets API Ruby Quickstart"

      # Authorize with credentials.json
      scopes = [ Google::Apis::SheetsV4::AUTH_SPREADSHEETS_READONLY ]
      authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
        json_key_io: File.open(credentials_path),
        scope: scopes
      )

      service.authorization = authorizer

      # Get spreadsheet details
      spreadsheet = service.get_spreadsheet(spreadsheet_id)

      # Extract sheet names
      sheet_names = spreadsheet.sheets.map { |sheet| sheet.properties.title }

      sheet_names
    end

    def get_spreadsheet_data(spreadsheet_id, sheet_name, credentials_path)
      service = Google::Apis::SheetsV4::SheetsService.new
      service.client_options.application_name = "Google Sheets API Ruby Quickstart"

      # Authorize with credentials.json
      scopes = [ Google::Apis::SheetsV4::AUTH_SPREADSHEETS_READONLY ]
      authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
        json_key_io: File.open(credentials_path),
        scope: scopes
      )

      service.authorization = authorizer

      # Get spreadsheet data
      response = service.get_spreadsheet_values(spreadsheet_id, sheet_name)
      response.values
    end

    def download_spreadsheet_csv(spreadsheet_id, credentials_path, destination_path)
      drive_service = Google::Apis::DriveV3::DriveService.new
      drive_service.client_options.application_name = "Google Drive API Ruby Quickstart"

      # Authorize with credentials.json
      scopes = [ Google::Apis::DriveV3::AUTH_DRIVE_FILE ]
      authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
        json_key_io: File.open(credentials_path),
        scope: scopes
      )

      drive_service.authorization = authorizer

      # Download the file
      file = drive_service.get_file(spreadsheet_id, download_dest: destination_path)
      file
    end

    # Now use the connection to make a request to the Google Sheets API.
    # For example, to get the list of spreadsheets.
    def get_spreadsheets
      connection.get("/v4/spreadsheets")
    end

    def get_auth_url
      "#{BASE_AUTH_URL}?client_id=#{@client_id}&redirect_uri=#{@redirect_uri}&response_type=code&scope=https://www.googleapis.com/auth/spreadsheets"
    end

    def get_token(code)
      response = HTTParty.post(BASE_TOKEN_URL, body: {
        client_id: @client_id,
        client_secret: @client_secret,
        redirect_uri: @redirect_uri,
        code: code,
        grant_type: "authorization_code"
      })
      JSON.parse(response.body)
    end

    def refresh_token(refresh_token)
      response = HTTParty.post(BASE_TOKEN_URL, body: {
        client_id: @client_id,
        client_secret: @client_secret,
        refresh_token: refresh_token,
        grant_type: "refresh_token"
      })
      JSON.parse(response.body)
    end

    def revoke_token(token)
      response = HTTParty.post(BASE_TOKEN_URL, body: {
        token: token,
        client_id: @client_id,
        client_secret: @client_secret
      })
      JSON.parse(response.body)
    end
  end
end
