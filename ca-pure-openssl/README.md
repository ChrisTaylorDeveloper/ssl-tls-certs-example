# CA pure openssl

Create a certificate Authority with openssl.
Then, self-sign a certificate with that CA.

1. Set your domain in `.env`
1. Read and run `run.sh`
1. Locate your CA `.crt` file in `certs-keys/`
1. If using Chrome, add your CA on page chrome://certificate-manager/
1. Add your domain and any subdomain to your `/etc/hosts` file.
1. With Chrome, visit <https://your.domain>, <https://sub1.your.domain> etc.
