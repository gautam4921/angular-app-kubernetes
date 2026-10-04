# =========================================================

# Stage 1 - Build Angular application

# =========================================================

FROM node:20 AS node

WORKDIR /app

# Required for older Angular/Webpack versions

ENV NODE_OPTIONS=--openssl-legacy-provider

# Copy package files

COPY package*.json ./

# Install dependencies

RUN npm ci

# Copy Angular application

COPY . .

# Build Angular application

RUN npm run build -- --configuration production

# =========================================================

# Stage 2 - NGINX

# =========================================================

FROM nginx:alpine

# Remove default NGINX configuration

RUN rm -f /etc/nginx/conf.d/default.conf

# Copy custom Angular SPA NGINX configuration

COPY nginx.conf /etc/nginx/conf.d/default.conf

# angular.json:

# "outputPath": "dist/angular-app"

COPY --from=node /app/dist/angular-app/ /usr/share/nginx/html/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]



