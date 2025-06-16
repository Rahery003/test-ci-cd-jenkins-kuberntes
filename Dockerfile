# Étape 1 - Build
FROM node:22 AS build
WORKDIR /app
COPY . .

RUN npm install && npm run build

# Étape 2 - Serve
FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
