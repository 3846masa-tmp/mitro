# Mitro over CentOS

Forked from [servomac/mitro](https://github.com/servomac/mitro).

---

A first attempt to dockerize the [Mitro Password Manager](https://github.com/mitro-co/mitro) after being [released](http://labs.mitro.co/2014/07/31/mitro-is-joining-twitter/) under GPL. I claim no authority in the field, i'm just trying to set up a simple deployment process for a Mitro server. Contributions are welcomed!

## Quick Start

1. Config docker-compose.yml

  - Default data folder is ``/data/mitro``.
  - You should set ``DOMAIN`` and ``VIRTUAL_HOST``.
  - You should set ``MAILGUN_API_KEY`` and ``MAILGUN_DOMAIN``

2. Execute docker-compose

  ```
  docker-compose up -d
  ```

  First time, start-up is very slow ( because of building the browser extensions ).

## Generate the browser extensions

Once you have the server up and running, docker generate the Chrome extension automatically.

## Backup

```
docker run -it --link mitro_postgres_1:db --rm postgres sh -c 'PGPASSWORD=$DB_ENV_POSTGRES_PASSWORD exec pg_dump -h "$DB_PORT_5432_TCP_ADDR" -p "$DB_PORT_5432_TCP_PORT" -U postgres mitro' | bzip2 > mitro.sql.bz2
```

## References

* [Building/running a server on Linux](https://github.com/mitro-co/mitro/issues/56)
* [Mitro Login Manager On-Premise](https://www.hashtagsecurity.com/mitro-login-manager-on-premise-2/)
* [Ansible configurations for Mitro](https://github.com/mitro-co/mitro/blob/ae43f8346de6c3e9818988a08cea448393e4af52/mitro-core/production/ansible/README.md)
