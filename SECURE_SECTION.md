# Secure Section - Webmaster Instructions

## Adding Files

Files go in: `storage/secure/`

```bash
# Add a file
cp myfile.pdf storage/secure/

# Files appear automatically in directory listing at /secure
```

### Supported File Types

Files are served with proper content types for inline browser viewing:

- **Text**: .txt, .html, .css, .js, .json, .xml
- **Images**: .jpg, .jpeg, .png, .gif, .webp, .svg
- **Video**: .mp4, .webm
- **Audio**: .mp3, .wav, .ogg
- **Documents**: .pdf
- **Archives**: .zip, .gz, .tar

Clicking a file in the directory listing displays it in the browser (when possible).

## Managing Access

Edit: `config/secure_credentials.yml`

### Add New User

```yaml
auth_message: Secure Area Access

credentials:
  - username: alphabet
    password: guillermo
    active_at: 2026-01-01
    inactive_at: 2027-12-31

  - username: newuser
    password: newpass
    active_at: 2026-02-01
    inactive_at: 2026-06-30
```

### Date Fields

- `active_at`: When credential becomes active (YYYY-MM-DD)
- `inactive_at`: When credential expires (YYYY-MM-DD)
- Leave blank for no restrictions

### Change Auth Message

Edit the `auth_message` field (3 words recommended)

## Access

URL: `/secure` or `./secure`

Browser will prompt for username/password.

## Security Notes

- `config/secure_credentials.yml` is in `.gitignore` - credentials not committed
- Use `config/secure_credentials.yml.sample` as template
- Files in `storage/secure/` are only accessible via authenticated route
- Direct URL access blocked - all requests require HTTP Basic Auth
