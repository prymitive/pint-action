FROM ghcr.io/cloudflare/pint:0.33.1
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
