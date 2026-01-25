class PagesController < ActionController::Base
  layout false
  before_action :authenticate_with_yaml, only: [:secure, :secure_file]

  def index
  end

  def secure
    @secure_path = Rails.root.join('storage', 'secure')
    @files = list_directory_contents(@secure_path)
  end

  def secure_file
    file_path = Rails.root.join('storage', 'secure', params[:filename])

    # Security check: ensure file is within secure directory
    secure_dir = Rails.root.join('storage', 'secure').to_s
    unless file_path.realpath.to_s.start_with?(secure_dir)
      head :forbidden
      return
    end

    if File.exist?(file_path) && File.file?(file_path)
      content_type = get_content_type(file_path)
      send_file file_path,
                disposition: 'inline',
                type: content_type
    else
      head :not_found
    end
  rescue Errno::ENOENT
    head :not_found
  end

  private

  def list_directory_contents(directory_path)
    return [] unless Dir.exist?(directory_path)

    entries = Dir.entries(directory_path).reject { |f| f.start_with?('.') }

    entries.map do |entry|
      full_path = File.join(directory_path, entry)
      {
        name: entry,
        type: File.directory?(full_path) ? 'directory' : 'file',
        size: File.directory?(full_path) ? nil : File.size(full_path),
        modified: File.mtime(full_path)
      }
    end.sort_by { |e| [e[:type] == 'directory' ? 0 : 1, e[:name]] }
  end

  def authenticate_with_yaml
    yaml_data = load_yaml_data
    auth_message = yaml_data['auth_message'] || 'Secure Area Access'

    authenticate_or_request_with_http_basic(auth_message) do |username, password|
      credentials = yaml_data['credentials'] || []
      valid_credential = credentials.find do |cred|
        cred['username'] == username &&
        cred['password'] == password &&
        credential_active?(cred)
      end
      valid_credential.present?
    end
  end

  def load_yaml_data
    yaml_path = Rails.root.join('config', 'secure_credentials.yml')
    YAML.load_file(yaml_path, permitted_classes: [Date, Symbol])
  end

  def load_credentials
    yaml_data = load_yaml_data
    yaml_data['credentials'] || []
  end

  def credential_active?(credential)
    today = Date.today
    active_at = credential['active_at'] ? Date.parse(credential['active_at'].to_s) : nil
    inactive_at = credential['inactive_at'] ? Date.parse(credential['inactive_at'].to_s) : nil

    # Check if today is within the active period
    active = true
    active = today >= active_at if active_at
    active = active && today <= inactive_at if inactive_at
    active
  end

  def get_content_type(file_path)
    extension = File.extname(file_path)[1..-1]&.downcase

    content_types = {
      'txt' => 'text/plain',
      'html' => 'text/html',
      'htm' => 'text/html',
      'css' => 'text/css',
      'js' => 'application/javascript',
      'json' => 'application/json',
      'xml' => 'application/xml',
      'pdf' => 'application/pdf',
      'jpg' => 'image/jpeg',
      'jpeg' => 'image/jpeg',
      'png' => 'image/png',
      'gif' => 'image/gif',
      'webp' => 'image/webp',
      'svg' => 'image/svg+xml',
      'mp4' => 'video/mp4',
      'webm' => 'video/webm',
      'mp3' => 'audio/mpeg',
      'wav' => 'audio/wav',
      'ogg' => 'audio/ogg',
      'zip' => 'application/zip',
      'gz' => 'application/gzip',
      'tar' => 'application/x-tar'
    }

    content_types[extension] || 'application/octet-stream'
  end
end
