FROM nginx:stable
# Optional: custom landing page so you can see new versions roll out
RUN printf '<h1>Hello from CI/CD </h1><p>Commit: %s</p>' "$COMMIT_SHA" > /usr/share/nginx/html/index.html

