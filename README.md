# Momo Store aka Пельменная №2

<img width="900" alt="image" src="https://user-images.githubusercontent.com/9394918/167876466-2c530828-d658-4efe-9064-825626cc6db5.png">

```

Инфраструктура описана и хранится отдельно в https://gitlab.praktikum-services.ru/std-028-38/momo-store-infrastructure

Ссылки:
- Магазин Пельманная https://momo-store.artem4eg.cc
- Prometheus https://prometheus.artem4eg.cc
- Grafana https://grafana.artem4eg.cc

```
# Описание

1. Запустить terraform, который установит Kubernetes, S3 и DNS в облаке Yandex
2. Развернуть  вспомогательную  инфраструктуру, которая находится в проекте momo-store-infrastructure,
   папка infra-helm-charts. Это cert-manager, gitlab-runner, ingress-nginx, prometheus, grafana, loki.
   momo-store helm находятся в Nexus.
3. Развернуть Momo Store из проекта "momo-store". 


# Структура

- Состоит из двух проектов:
    - [momo-store](https://gitlab.praktikum-services.ru/std-028-38/momo-store)
    - [momo-store-infrastructure](https://gitlab.praktikum-services.ru/std-028-38/momo-store-infrastructure) 

- "momo-store" содержит код frontend и backend.
- "momo-store-infrastructure" содержит terraform и helm charts, которые необходимы для развертывания инфраструктуры.


# momo-store

Запускаются 2 теста SAST и SonarQube. Сборка приложения выполняется сразу в контейнеры, которые сохраняются в  Gitlab "Container Registry", затем деплоятся в кластер Kubernetes с помощью helm из Nexus, развернутый в Яндекс.Облаке.
Версия контейнеров  формируется 1.0.${CI_PIPELINE_ID}

## Frontend

1. контейнер собирает и компилирует приложение, используя Node.js.
2. создается финальный контейнер, который использует Nginx для обслуживания скомпилированного приложения.

Dockerfile:

```
FROM node:16.6-alpine3.14 AS builder

WORKDIR /app
COPY . .
RUN npm install
RUN npm run build

FROM nginx:stable-alpine

COPY --from=builder /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

## Backend

Картинки, которые использует сайт, необходимые для работы, хранятся в S3 (momo-store-std-028-38).

1. контейнер с Go компилятором собирает приложение из исходного кода, предварительно выполняя тесты и загружая   зависимости.
2. создается легковесный контейнер на основе Alpine Linux, в который копируется только исполняемый файл.

Dockerfile:

```
FROM golang:1.21 AS builder

WORKDIR /app
COPY . .
RUN go test -v ./... \
   && go mod download \
   && go get ./... 
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o backend ./cmd/api

FROM alpine:latest

WORKDIR /app
COPY --from=builder /app/backend .
EXPOSE 8081
CMD ["./backend"]
```
# momo-store-infrastructure
- infra-helm-charts
- momo-store-chart
- terraform

## infra-helm-charts
Вспомогательные helm charts необходимые для работы Momo Store

## momo-store-chart
- momo-backend-helm
- momo-frontend-helm

При изменении манифеста запускается gitlab-ci, который создает helm package и загружает helm в Nexus.
Версия helm chart формируется 0.1.$CI_PIPELINE_ID

## terraform

Состояние Terraform'а хранится в S3 (bucket-std-028-38)

```export YC_TOKEN=$(yc iam create-token)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)
export ACCESS_KEY="<идентификатор_ключа>"
export SECRET_KEY="<секретный_ключ>"

terraform init -backend-config="access_key=$ACCESS_KEY" -backend-config="secret_key=$SECRET_KEY"
terraform apply -var="folder_id=$YC_FOLDER_ID"
```

# Monitoring & Logging

- [Prometheus](https://prometheus.artem4eg.cc/)
- [Grafana](https://grafana.artem4eg.cc/)

- [infrastructure](https://grafana.artem4eg.cc/d/85a562078cdf77779eaa1add43ccec1e/kubernetes-compute-resources-namespace-pods?orgId=1&refresh=10s&var-datasource=default&var-cluster=&var-namespace=default)

<img width="500" alt="image" src="https://storage.yandexcloud.net/momo-store-std-028-38/monitoring/Screenshot%20from%202024-08-27%2017-25-39.png">

- [frontend](https://grafana.artem4eg.cc/d/MsjffzSZz/nginx-exporter?orgId=1)

<img width="500" alt="image" src="https://storage.yandexcloud.net/momo-store-std-028-38/monitoring/Screenshot%20from%202024-08-27%2017-39-17.png">

- [backend](https://grafana.artem4eg.cc/d/adw0ju3e07i80d/momo-store?orgId=1&from=now-6h&to=now)

<img width="500" alt="image" src="https://storage.yandexcloud.net/momo-store-std-028-38/monitoring/Screenshot%20from%202024-08-27%2017-43-27.png">

- [logs](https://grafana.artem4eg.cc/d/o6-BGgnnk/loki-kubernetes-logs?orgId=1&var-query=&var-namespace=default&var-stream=All&var-container=momo-store-backend&var-container=momo-store-frontend)

<img width="500" alt="image" src="https://storage.yandexcloud.net/momo-store-std-028-38/monitoring/Screenshot%20from%202024-08-27%2017-47-22.png">