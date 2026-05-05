# Triggers

| Name | Severity | Condition |
|------|----------|-----------|
| Apache: mod_status unreachable | High | no data for 5m on `apache.busy_workers` |
| Apache: BusyWorkers utilization is high | Warning | `BusyWorkers > MaxRequestWorkers * BUSY.HIGH.PCT / 100` |
| Apache: no idle workers available | Average | `IdleWorkers=0 AND BusyWorkers>0` |

## Macros

| Macro | Default | Description |
|-------|---------|-------------|
| `{$ZBX.APACHE.ENDPOINT}` | `127.0.0.1` | mod_status host:port |
| `{$ZBX.APACHE.MAX_WORKERS}` | `256` | match `MaxRequestWorkers` in MPM config |
| `{$ZBX.APACHE.BUSY.HIGH.PCT}` | `80` | high-utilization threshold, percent |

## Verifying mod_status

```sh
curl -s "http://127.0.0.1/server-status?auto"
```

You should see `Total Accesses`, `BusyWorkers`, `Scoreboard:` lines. If not,
`a2enmod status` and reload Apache.
