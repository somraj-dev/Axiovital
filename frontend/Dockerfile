FROM ghcr.io/cirruslabs/flutter:3.41.6 AS build

WORKDIR /app

# Copy the manually scouted files
COPY . .

# Hardening the build environment: prevent git safety errors and disable analytics
RUN git config --global --add safe.directory /app
RUN flutter config --no-analytics

# Ensure a clean state and get dependencies
RUN flutter clean
RUN flutter pub get

# Build the Flutter app for the web
RUN flutter build web --release --no-tree-shake-icons

# Serve the app using Nginx
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
