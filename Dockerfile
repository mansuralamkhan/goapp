FROM golang:1.16-alpine as builder

WORKDIR /app

COPY . .

RUN go build -o app main.go

FROM alpine:latest

WORKDIR /root/

COPY --from=builder /app/app .

EXPOSE 8081

CMD ["./app"]
