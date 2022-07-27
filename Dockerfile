FROM ghcr.io/cloudflare/pint:0.27.0
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
