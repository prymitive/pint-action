FROM ghcr.io/cloudflare/pint:0.32.1
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
