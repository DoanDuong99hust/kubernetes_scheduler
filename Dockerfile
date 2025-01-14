FROM golang:1.13-alpine as builder
ARG VERSION=0.0.1

ENV GO111MODULE=on
ENV CGO_ENABLED=0
ENV GOOS=linux
ENV GOARCH=amd64

# build
WORKDIR /go/src/duong-scheduler
COPY go.mod .
COPY go.sum .
RUN GO111MODULE=on go mod download
COPY . .
RUN go install -ldflags "-s -w -X main.version=$VERSION" duong-scheduler

# runtime image
FROM gcr.io/google_containers/ubuntu-slim:0.14
COPY --from=builder /go/bin/duong-scheduler /usr/bin/duong-scheduler
ENTRYPOINT ["duong-scheduler"]
