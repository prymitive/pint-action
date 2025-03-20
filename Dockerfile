FROM ghcr.io/cloudflare/pint:0.71.8
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
