FROM ghcr.io/cloudflare/pint:0.38.1
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
