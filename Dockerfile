FROM ghcr.io/cloudflare/pint:0.74.7
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
