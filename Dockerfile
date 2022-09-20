FROM ghcr.io/cloudflare/pint:0.30.1
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
