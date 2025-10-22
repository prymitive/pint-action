FROM ghcr.io/cloudflare/pint:0.76.1
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
