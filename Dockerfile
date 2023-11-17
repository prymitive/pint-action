FROM ghcr.io/cloudflare/pint:0.49.2
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
