# =========================================================

# Stage 1 - Build Angular application

# =========================================================

FROM node:20 AS node

WORKDIR /app

COPY package*.json ./

RUN npm ci

COPY . .

RUN npm run build -- --configuration production

# =========================================================

# Stage 2 - NGINX

# =========================================================

FROM nginx:alpine

# Remove default NGINX configuration

RUN rm /etc/nginx/conf.d/default.conf

# Copy custom Angular SPA NGINX configuration

COPY nginx.conf /etc/nginx/conf.d/default.conf

# Angular build output

COPY --from=node /app/dist/angular-app/ /usr/share/nginx/html/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

