FROM node:20 AS node

WORKDIR /app

ENV NODE_OPTIONS=--openssl-legacy-provider

COPY package*.json ./

RUN npm ci

COPY . .

RUN npm run build -- --configuration production

# Verify Angular generated the expected output

RUN echo "===== Angular build output =====" && 
find /app/dist -maxdepth 3 -type f | sort

FROM nginx:alpine

RUN rm -f /etc/nginx/conf.d/default.conf

COPY nginx.conf /etc/nginx/conf.d/default.conf

COPY --from=node /app/dist/angular-app/ /usr/share/nginx/html/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

