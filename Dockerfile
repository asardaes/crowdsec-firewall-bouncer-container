FROM alpine:latest AS downloader
RUN apk --update --no-cache add curl jq tar \
    && curl -sS https://api.github.com/repos/crowdsecurity/cs-firewall-bouncer/releases/latest | \
      jq -re '.assets[] | select(.name=="crowdsec-firewall-bouncer-linux-amd64.tgz") | .url' | \
      xargs -I{} curl -sSLH "Accept: application/octet-stream" -o /tmp/csfwb.tgz {} \
    && tar -xzv -C /tmp -f /tmp/csfwb.tgz

FROM alpine:latest
COPY --from=downloader /tmp/crowdsec-firewall-bouncer-*/crowdsec-firewall-bouncer /usr/local/bin/
RUN apk --update --no-cache add nftables
ENTRYPOINT ["/usr/local/bin/crowdsec-firewall-bouncer"]
