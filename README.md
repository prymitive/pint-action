# pint action

This action will run [pint](https://github.com/cloudflare/pint)
to validate Prometheus rules.

## Inputs

### `workdir`

Directory to run check against. Default is `"."`.

### `config`

Config file to use. Default is `""`, meaning no `--config` flag will be passed
to `pint` and it will use defaults.

### `loglevel`

Log level for pint. Default is `""`, meaning no `--log-level` flag will be passed
to `pint` and it will use defaults.

## Example usage

```YAML
uses: prymitive/pint-action@v0.1
with:
  workdir: 'rules'
  config: 'pint.yaml'
  loglevel: 'debug'
```
