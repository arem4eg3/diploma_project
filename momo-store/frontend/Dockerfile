FROM node:16.6-alpine3.14 AS builder

WORKDIR /app
COPY . .
RUN npm install
RUN npm run build

FROM nginx:stable-alpine

COPY --from=builder /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]