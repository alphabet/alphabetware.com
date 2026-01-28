class SecureFilesMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)

    # Only intercept /secure/* paths (but not /secure itself for directory listing)
    if request.path.start_with?('/secure/') && (request.get? || request.head?)
      handle_secure_file(env, request)
    else
      @app.call(env)
    end
  end

  private

  def handle_secure_file(env, request)
    # Authenticate
    unless authenticated?(env)
      return auth_required_response
    end

    # Get file path
    path_info = request.path.sub('/secure/', '')
    file_path = Rails.root.join('storage', 'secure', path_info)

    # Check if file/directory exists first
    unless File.exist?(file_path)
      return [404, {'Content-Type' => 'text/plain'}, ['Not Found']]
    end

    # Security check: ensure file is within secure directory
    secure_dir = Rails.root.join('storage', 'secure').realpath.to_s
    unless file_path.realpath.to_s.start_with?(secure_dir)
      return [403, {'Content-Type' => 'text/plain'}, ['Forbidden']]
    end

    # Handle directory by looking for index.html
    if File.directory?(file_path)
      # Redirect to add trailing slash if missing (for correct relative URLs)
      unless request.path.end_with?('/')
        return [301, {'Location' => request.path + '/', 'Content-Type' => 'text/html'}, ['Moved Permanently']]
      end

      index_path = file_path.join('index.html')
      if File.exist?(index_path) && File.file?(index_path)
        file_path = index_path
      else
        # No index.html, let Rails controller handle directory listing
        return @app.call(env)
      end
    end

    # Serve file if it exists
    if File.exist?(file_path) && File.file?(file_path)
      serve_file(file_path)
    else
      [404, {'Content-Type' => 'text/plain'}, ['Not Found']]
    end
  end

  def authenticated?(env)
    auth = Rack::Auth::Basic::Request.new(env)

    return false unless auth.provided? && auth.basic?

    username, password = auth.credentials
    yaml_data = load_yaml_data
    credentials = yaml_data['credentials'] || []

    credentials.any? do |cred|
      cred['username'] == username &&
      cred['password'] == password &&
      credential_active?(cred)
    end
  end

  def auth_required_response
    yaml_data = load_yaml_data
    auth_message = yaml_data['auth_message'] || 'Secure Area Access'

    [401,
     {'Content-Type' => 'text/html', 'WWW-Authenticate' => %(Basic realm="#{auth_message}")},
     ['Unauthorized']]
  end

  def serve_file(file_path)
    content_type = get_content_type(file_path)
    body = File.read(file_path)

    [200,
     {'Content-Type' => content_type, 'Content-Length' => body.bytesize.to_s},
     [body]]
  end

  def load_yaml_data
    yaml_path = Rails.root.join('config', 'secure_credentials.yml')
    YAML.load_file(yaml_path, permitted_classes: [Date, Symbol])
  end

  def credential_active?(credential)
    today = Date.today
    active_at = credential['active_at'] ? Date.parse(credential['active_at'].to_s) : nil
    inactive_at = credential['inactive_at'] ? Date.parse(credential['inactive_at'].to_s) : nil

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
