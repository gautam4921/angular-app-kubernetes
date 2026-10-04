# =========================================================
# Stage 1 - Build Angular application
# =========================================================

FROM node:20 AS node

WORKDIR /app

# Copy package files first for Docker layer caching
COPY package*.json ./

# Install exact dependency versions
RUN npm ci

# Copy Angular application
COPY . .

# Production build
RUN npm run build -- --configuration production


# =========================================================
# Stage 2 - NGINX
# =========================================================

FROM nginx:alpine

# Copy Angular build output
COPY --from=node /app/dist/ /usr/share/nginx/html/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

