############################
# Build an executable binary
############################
FROM golang:alpine AS builder 

RUN apk update && apk add --no-cache git
RUN adduser -D -g '' gouser

WORKDIR $GOPATH/src/technical-exercise/main
COPY ./main.go .

RUN go get -d -v
RUN go build -o /go/bin/technical-exercise

############################
# Build a small image
############################
FROM alpine

WORKDIR /webserver

COPY --from=builder /go/bin/technical-exercise /go/bin/technical-exercise
COPY --from=builder /etc/passwd /etc/passwd

EXPOSE 3000

USER gouser

ENTRYPOINT /go/bin/technical-exercise
