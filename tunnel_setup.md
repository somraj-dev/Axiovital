# Professional Domain for Local Testing

To achieve a "Premium" feel like Instagram or Twitter on your mobile device, you need a real domain name and HTTPS. Using an IP address like `192.168.x.x` will always show browser warnings and break the "Big App" experience.

## The Professional Solution: Cloudflare Tunnel (Free)

This service creates a secure "tunnel" from your local Docker container to a real, professional URL (e.g., `axio-dev.yourdomain.com`).

### Steps to Setup:

1. **Install Cloudflared**:
   - Download the Cloudflare Tunnel client on your computer.

2. **Login & Create Tunnel**:
   ```bash
   cloudflared tunnel login
   cloudflared tunnel create axiovital
   ```

3. **Configure the Tunnel**:
   Create a `config.yml` that points to your Docker container:
   ```yaml
   url: http://localhost:3000
   tunnel: <your-tunnel-id>
   credentials-file: <path-to-json-file>
   ```

4. **Run the Tunnel**:
   ```bash
   cloudflared tunnel run axiovital
   ```

5. **Update Supabase**:
   - Go to your Supabase Dashboard.
   - Add your new Tunnel URL (e.g., `https://axio-dev.yourdomain.com`) to the **Redirect URLs**.

### Why this is "Premium":
- **No Browser Bars**: If you use the "Add to Home Screen" feature on your phone with a real domain, the browser address bar disappears completely.
- **SSL/HTTPS**: You get a green lock icon, which is mandatory for Google Login to look professional.
- **Brand Identity**: Users see `axiovital.com` instead of a scary-looking IP address.
