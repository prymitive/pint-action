FROM ghcr.io/cloudflare/pint:0.73.7
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
