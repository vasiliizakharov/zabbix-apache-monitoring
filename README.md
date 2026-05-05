# zabbix-apache-monitoring

Zabbix 7.0 template for Apache HTTP Server using `mod_status`. Pure agent
UserParameters, no PHP scrapers and no Java gateway.

## What it monitors

- BusyWorkers / IdleWorkers
- Requests per second / bytes per second / bytes per request
- Total accesses, total kBytes
- Server uptime, CPU load
- Scoreboard slot counts (`W`, `K`, `R`, `D`, `G`, `L`, ...)

## Requirements

- Zabbix agent 5.0+
- Apache 2.4 with `mod_status` enabled

### Apache configuration

```apache
LoadModule status_module modules/mod_status.so

<Location /server-status>
    SetHandler server-status
    Require local
</Location>
ExtendedStatus On
```

Reload Apache and verify locally:

```sh
curl -s 'http://127.0.0.1/server-status?auto'
```

If you serve mod_status on a non-default vhost or port, set
`{$ZBX.APACHE.ENDPOINT}` accordingly (for example `127.0.0.1:8080`).

## Install

```sh
sudo ./install.sh
```

Then import `template/template.yaml` in the Zabbix UI.

## Items

- `apache.status.raw[host:port]` (master text item, optional)
- `apache.busy_workers`, `apache.idle_workers`
- `apache.req_per_sec`, `apache.bytes_per_sec`, `apache.bytes_per_req`
- `apache.uptime`, `apache.cpu_load`
- `apache.total_accesses`, `apache.total_kbytes`
- `apache.scoreboard[host:port,W|K|R|D|G|L|...]`

## Triggers

See [docs/triggers.md](docs/triggers.md).

## Macros

| Macro | Default |
|-------|---------|
| `{$ZBX.APACHE.ENDPOINT}` | `127.0.0.1` |
| `{$ZBX.APACHE.MAX_WORKERS}` | `256` |
| `{$ZBX.APACHE.BUSY.HIGH.PCT}` | `80` |

## Troubleshooting

- `zabbix_get -s 127.0.0.1 -k 'apache.busy_workers[127.0.0.1]'` should return
  an integer.
- 403 from `/server-status` usually means `Require local` is blocking the
  agent. Use `Require ip 127.0.0.1` if you bind on a non-loopback address.
- Empty value: enable `ExtendedStatus On` (Apache 2.4 enables it implicitly,
  but some distributions disable it).

## License

MIT — see [LICENSE](LICENSE).
