# SSL self-signed and wildcard check

## Localhost example

This example creates and uses a self-signed cert for the 'localhost' domain:

1. Change to `localhost-example` directory.
1. Run `create-cert-localhost.sh` (see [letsencrypt certs for localhost](https://letsencrypt.org/docs/certificates-for-localhost/)).
1. Run `docker compose up --build`.
1. Visit <https://localhost>
1. Accept browser warning.

## Wildcard example

Add to your system hosts file

```shell
127.0.0.1    code-plug-shoe.com
127.0.0.1    foo.code-plug-shoe.com
127.0.0.1    bar.code-plug-shoe.com
```

1. Change to `wildcard-example` directory.
1. Run `create-cert-wildcard.sh`.
1. Run `docker compose up --build`.
1. Visit any of
    * <https://code-plug-shoe.com>
    * <https://foo.code-plug-shoe.com>
    * <https://bar.code-plug-shoe.com>
1. Accept browser warning.

## Notes

1. To view the certificate in Chrome, go to developer tools > Privacy and
security > View certificate.
