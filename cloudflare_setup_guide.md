# 🚀 Full Guide: Professional Domain via Cloudflare Tunnel

Follow these steps to get a professional `https://` URL for your Axiovital app. This will allow you to test Google Login on your phone with a "Big App" feel.

---

## 1. Prerequisites
- A **Cloudflare Account** (Free)
- A **Domain Name** (e.g., `yourname.com`) added to your Cloudflare account.
- **Docker** running your app on `localhost:3000`.

---

## 2. Install Cloudflared
You need the Cloudflare Tunnel client on your machine.

- **Windows (PowerShell)**:
  ```powershell
  winget install Cloudflare.cloudflared
  ```
- **Mac (Homebrew)**:
  ```bash
  brew install cloudflared
  ```

---

## 3. Login to Cloudflare
In your terminal, run the following command. It will open a browser window for you to authorize your domain.
```bash
cloudflared tunnel login
```
*Select the domain you want to use for the app.*

---

## 4. Create the Tunnel
Run this command to create a tunnel specifically for Axiovital:
```bash
cloudflared tunnel create axiovital
```
**Important**: Note down the **Tunnel ID** (a long string of numbers and letters) that appears in the output.

---

## 5. Map your Domain (DNS)
Now, tell Cloudflare to point a subdomain to this tunnel. Replace `<tunnel-id>` with your ID and `app.yourdomain.com` with your desired URL.
```bash
cloudflared tunnel route dns axiovital app.yourdomain.com
```

---

## 6. Run the Tunnel
Connect your local Docker app (`localhost:3000`) to the tunnel:
```bash
cloudflared tunnel run --url http://localhost:3000 axiovital
```
*Your app is now live at `https://app.yourdomain.com`!*

---

## 7. Final Step: Update Supabase
For Google Login to work on this new domain, you must whitelist it:
1. Go to **Supabase Dashboard** -> **Authentication** -> **URL Configuration**.
2. Add `https://app.yourdomain.com` to the **Redirect URLs**.
3. Save changes.

---

## 💡 How to get the "Big App" (No Browser Bar) Experience
1. Open `https://app.yourdomain.com` in **Chrome** (Android) or **Safari** (iOS) on your phone.
2. Tap the **Menu/Share** icon.
3. Select **"Add to Home Screen"**.
4. Open the app from your home screen.
   - The browser address bar will be **hidden**.
   - It will look and feel exactly like a native "Premium" app.
