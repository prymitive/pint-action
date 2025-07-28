FROM ghcr.io/cloudflare/pint:0.74.5
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
