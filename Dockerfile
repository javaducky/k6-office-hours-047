# Multi-stage build to generate custom k6 with extension

# Stage 1 - download xk6 and desired extensions, then compile a new binary.
#
FROM golang:1.18-alpine as builder
WORKDIR $GOPATH/src/go.k6.io/k6
ADD . .
RUN apk --no-cache add build-base git
RUN go install go.k6.io/xk6/cmd/xk6@latest

# 
# 1) Copy the following `--with ...` line, modifying the module name for additional extension(s).
# 2) CGO_ENABLED will ideally be '0' (disabled), but some extensions require it be enabled. (See docs for your extensions)
#
RUN CGO_ENABLED=0 xk6 build \
    --with github.com/grafana/xk6-output-prometheus-remote \
    --with github.com/grafana/xk6-output-timescaledb \
    --with github.com/grafana/xk6-output-influxdb \
    --output /tmp/k6


# Stage 2 - Copy our custom k6 for use within a minimal linux image.
#
FROM alpine:3.15
RUN apk add --no-cache ca-certificates \
    && adduser -D -u 12345 -g 12345 k6
COPY --from=builder /tmp/k6 /usr/bin/k6

USER 12345
WORKDIR /home/k6

ENTRYPOINT ["k6"]
