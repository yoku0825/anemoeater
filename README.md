# anemoeater

anemo *eat* er is wrapper script of [box/Anemometer](https://github.com/box/Anemometer) and pt-query-digest in [percona-toolkit](https://github.com/percona/percona-toolkit).

## QuickStart

* You have to install docker and percona-toolkit.

```
$ git clone https://github.com/yoku0825/anemoeater
$ cd anemoeater
$ cpanm --installdeps .
$ ./anemoeater path_to_slow_log
```

* Then anemoeater starts container of [yoku0825/anemoeater](https://hub.docker.com/r/yoku0825/anemoeater/) and displays URL which is used to access Anemometer via browser, and parse your slow_log using pt-query-digest.
* anemoeater splits slow_qeury and passes pt-query-digest, because when you pass whole slow_query to pt-query-digest, pt-query-digest will summerize queries by (checksum, ts_min, ts_max), this behavier is a way to avoid this summerize.
