# Art Direction Testing Mechanism

## Purpose
Quick A/B testing of design variations on real devices without deploying or complex setup.

## How It Works

### 1. Query String Parameters
Access different design variations via simple URLs:
```
http://192.168.68.116:3000/?4
http://192.168.68.116:3000/?6
http://192.168.68.116:3000/?7
```

### 2. ERB Conditional Rendering
Detect which variation to show based on query parameter presence:

```erb
<% demo = params.key?('4') ? '4' : params.key?('6') ? '6' : params.key?('7') ? '7' : 'default' %>

<div class="cover cover-<%= demo %>">
  <% if demo == '4' %>
    <!-- Variation 4 HTML -->
  <% elsif demo == '7' %>
    <!-- Variation 7 HTML -->
  <% else %>
    <!-- Default HTML -->
  <% end %>
</div>
```

### 3. CSS Class-Based Styling
Scope styles to each variation:

```scss
/* Variation 4 styles */
.cover-4 .cover__description {
    bottom: -30px;
}

/* Variation 7 styles */
.cover-7 .cover__description {
    bottom: 80px;
}

/* Default styles */
.cover__description {
    bottom: 0;
    position: absolute;
}
```

### 4. JavaScript Enhancement (Optional)
Add interactive behavior for specific variations:

```javascript
var urlParams = new URLSearchParams(window.location.search);
if (urlParams.has('6')) {
    // Parallax scroll behavior
    window.addEventListener('scroll', function() {
        // Custom interaction
    });
}
```

### 5. Debug Overlay
Add real-time technical info for testing:

```html
<div id="debug-info" style="position: fixed; top: 10px; right: 10px; ...">
    <!-- Shows viewport dimensions, element positions, etc. -->
</div>
```

## Local Device Testing Setup

### Start Server for Network Access
```bash
# Switch to correct Ruby version
source ~/.rvm/scripts/rvm && rvm use ruby-3.1.2

# Start server bound to all network interfaces
bin/rails server -b 0.0.0.0 -p 3000

# Find your local IP
ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | head -1
```

### Access from Mobile Device
1. Connect mobile device to same WiFi network
2. Navigate to `http://[YOUR_IP]:3000/?[variation]`
3. Test different variations by changing query parameter

## Benefits

- **Fast iteration**: No deployment required
- **Real device testing**: Test on actual Pixel 6a, iPhone, etc.
- **Side-by-side comparison**: Switch between variations instantly
- **Art director friendly**: Just change number in URL
- **Technical visibility**: Debug overlay shows what's happening
- **No database**: Variations defined in code, version controlled

## Use Cases

- Testing viewport height solutions for mobile browsers
- Comparing animation approaches
- Evaluating layout alternatives
- A/B testing color schemes
- Testing responsive breakpoints
- Evaluating typography choices

## Implementation Pattern

### Add New Variation

1. **Add query param check**:
   ```erb
   <% demo = params.key?('11') ? '11' : ... %>
   ```

2. **Add HTML variation**:
   ```erb
   <% elsif demo == '11' %>
     <!-- New variation HTML -->
   ```

3. **Add CSS styles**:
   ```scss
   .cover-11 .element {
       /* Variation styles */
   }
   ```

4. **Add JavaScript if needed**:
   ```javascript
   if (urlParams.has('11')) {
       // Variation behavior
   }
   ```

5. **Test**: http://[IP]:3000/?11

## Notes

- **Use grep -i** for case-insensitive log searches
- Keep variations small and focused
- Clean up unused variations after decision made
- Document what each variation tests
- Take screenshots for stakeholder review

## Real-World Example

**Problem**: "Guillermo Weinmann" hidden below mobile viewport due to address bar.

**Variations Tested**:
- `?4` - Hero Fold: Intentionally cut name in half
- `?6` - Parallax: Name slides up on scroll
- `?7` - Safe Zone: 80px margin from bottom
- `?8` - Overlay: Gradient with white text
- `?10` - Grid: CSS Grid with 100svh

**Result**: Art director can compare all 5 options on real Pixel 6a in < 2 minutes.
