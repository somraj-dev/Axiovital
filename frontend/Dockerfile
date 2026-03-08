FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app

# Copy the manually scouted files
COPY . .

# Generate the missing platform files safely by creating a dummy app and copying the web directory
RUN flutter create /tmp/dummy_app --platforms=web
RUN cp -r /tmp/dummy_app/web ./web

# Get dependencies
RUN flutter pub get

# Build the Flutter app for the web
RUN flutter build web

# Serve the app using Nginx
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
