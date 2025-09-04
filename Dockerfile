FROM ghcr.io/cloudflare/pint:0.74.8
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
