FROM ghcr.io/cloudflare/pint:0.73.6
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
