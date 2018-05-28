FROM golang:1.10 as builder
WORKDIR /go/src/github.com/openshift/autoheal/
COPY . .
RUN hack/build-go.sh

FROM alpine:latest
RUN apk --no-cache add ca-certificates

RUN useradd --no-create-home autoheal
USER autoheal
EXPOSE 9099

WORKDIR /bin
COPY --from=builder /go/src/github.com/openshift/autoheal/_output/local/bin/linux/amd64/autoheal .

LABEL io.k8s.display-name="OpenShift Autoheal"
LABEL io.k8s.description="OpenShift Autoheal"
LABEL io.openshift.tags="openshift"
CMD ["./autoheal"]
