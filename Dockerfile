FROM ghcr.io/cloudflare/pint:0.72.1
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
