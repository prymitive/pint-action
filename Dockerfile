FROM ghcr.io/cloudflare/pint:0.30.2
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
