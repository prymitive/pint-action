FROM ghcr.io/cloudflare/pint:0.89.4
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
