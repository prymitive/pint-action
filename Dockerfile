FROM ghcr.io/cloudflare/pint:0.56.2
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
