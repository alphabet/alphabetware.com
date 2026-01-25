# Rails Asset Pipeline - File Organization

## Directory Structure

### app/assets/ (Source Files - Use This)
**Purpose:** Source files that go through the Rails asset pipeline

```
app/assets/
├── images/          # Images, animations
├── videos/          # Video files
├── stylesheets/     # SCSS/CSS files
└── javascripts/     # JS files
```

**Benefits:**
- Asset fingerprinting for cache busting (e.g., `image-abc123.png`)
- Preprocessing (SCSS → CSS, CoffeeScript → JS)
- Minification and compression in production
- Use Rails helpers: `image_url()`, `asset_path()`, `video_tag()`
- Automatic optimization

**Always put source files here.**

### public/assets/ (Compiled Output - Don't Touch)
**Purpose:** Auto-generated compiled assets (production only)

- Rails generates this in production via `rails assets:precompile`
- Contains fingerprinted, minified versions of app/assets/ files
- **Never manually place files here**
- This directory should be in `.gitignore`

### public/ (Static Files)
**Purpose:** Files served directly by web server, bypassing Rails

```
public/
├── robots.txt
├── favicon.ico
├── 404.html
└── 500.html
```

**Use for:**
- Static HTML error pages
- robots.txt, sitemap.xml
- favicon.ico
- Files that should never change or be processed

**Don't use for:**
- Images, videos, stylesheets, scripts (use app/assets/ instead)

## File Organization

### Images → app/assets/images/
```
app/assets/images/
├── chatty-grey-squirrel.webp
├── comfyui-squirrel-prompt.png
└── hipster-party-squirrels.webp
```

Access in views:
```erb
<%= image_tag 'chatty-grey-squirrel.webp' %>
```

Access in SCSS:
```scss
background-image: image-url('chatty-grey-squirrel.webp');
```

### Videos → app/assets/videos/
```
app/assets/videos/
├── chatty-grey-squirrel.mp4
└── chatty-grey-squirrel.mov
```

Access in views:
```erb
<%= video_tag 'chatty-grey-squirrel.mp4', autoplay: true, loop: true, muted: true, playsinline: true %>
```

**Note:** MP4 format is preferred for web use (better browser support, smaller size, hardware acceleration on iOS). WebP animations have poor quality and limited support on iPhones. To convert WebP to MP4: `ffmpeg -i input.webp -c:v libx264 -pix_fmt yuv420p -movflags +faststart output.mp4`

**iPhone Autoplay:** For video autoplay on iPhone/iOS:
- Required attributes: `muted`, `playsinline`, `autoplay`
- JavaScript fallback: Try to play on user interaction if autoplay fails
- Hide controls: Use CSS webkit selectors to hide play button
- Test on actual device as desktop Safari differs from iOS Safari/Chrome

### Stylesheets → app/assets/stylesheets/
```
app/assets/stylesheets/
├── application.scss
└── styles.scss
```

### Large Files (>10MB) or User Uploads → storage/
Use Active Storage or place in `storage/` directory for:
- User-uploaded files
- Very large media files that shouldn't be in version control
- Files that change frequently

## Current Setup

✓ Source files moved to `app/assets/`
✓ `public/assets/` left for Rails to manage
✓ Static files remain in `public/`

## Production Deployment

When deploying:
```bash
RAILS_ENV=production rails assets:precompile
```

This compiles `app/assets/` → `public/assets/` with fingerprinted names.
