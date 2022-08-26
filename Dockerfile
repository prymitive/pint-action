FROM ghcr.io/cloudflare/pint:0.29.2
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
