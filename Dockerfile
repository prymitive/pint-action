FROM ghcr.io/cloudflare/pint:0.62.2
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
