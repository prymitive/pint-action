FROM ghcr.io/cloudflare/pint:0.82.1
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
