FROM alpine:3.12 as build
RUN apk add wget tar \
    && wget https://github.com/open-policy-agent/conftest/releases/download/v0.23.0/conftest_0.23.0_Linux_x86_64.tar.gz \
    && tar xzf conftest_0.23.0_Linux_x86_64.tar.gz \
    && mv conftest /usr/local/bin
COPY  policy /rules/policies
COPY deploy.yaml /rules
WORKDIR /rules
