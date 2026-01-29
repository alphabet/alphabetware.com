# Load and configure SecureFilesMiddleware
require Rails.root.join('lib', 'secure_files_middleware')

Rails.application.config.middleware.use SecureFilesMiddleware
