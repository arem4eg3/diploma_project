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