# go-web
A simple web server written in Go

## Three ways to get up and running

### Go
Run `go run main.go` or `go build main.go`.

If you run `go build main.go`, you'll need to run the binary by running `./main`.

### Docker
Run the following:
```
docker build -t local/go-web:alpine-test .  
docker run -p 8080:8080 local/go-web:alpine-test
```

### Docker Compose
Run `docker-compose up`.
