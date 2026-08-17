# Corporate certificates on macOS

> The certificate files are **not** stored in this public repository. Bring them over a secure channel (AirDrop, password manager, internal share) and then follow the steps below.

## Context (current Linux machine)

On Ubuntu, the corporate certificates lived in:

- `/usr/local/share/ca-certificates/uol/` (several `.crt`)
- `/etc/ssl/certs/ZscalerRootCertificate.pem`

And `~/.zshrc` exported:

```sh
export NODE_EXTRA_CA_CERTS=/etc/ssl/certs/ca-certificates.crt
```

Files involved (reference names): `caroot_2030.crt`, `CARootPags.cer/.crt`, `CARootUOL2044.crt`, `DigiCertGlobalRootCA.crt`, `pagpki_ca_root.crt`, `uolcorp.crt`, `vpns.crt`, `ZscalerRootCertificate.crt`.

## 1. Import into the system Keychain (macOS)

For each trusted root certificate file:

```sh
sudo security add-trusted-cert -d -r trustRoot \
  -k /Library/Keychains/System.keychain /path/to/the/cert.crt
```

Repeat for every corporate `.crt`/`.pem`. Verify afterwards in the **Keychain Access** app → **System** → **Certificates**.

## 2. Combine the certificates into a PEM bundle for Node

Unlike Linux, macOS has no single `ca-certificates.crt`. Create your own:

```sh
mkdir -p ~/.certs
cat /path/to/*.crt > ~/.certs/corp-ca-bundle.pem
```

## 3. Point the environment variables

In `~/.zshrc`, set the paths for macOS:

```sh
export NODE_EXTRA_CA_CERTS="$HOME/.certs/corp-ca-bundle.pem"
# Some ecosystems use their own variables:
export REQUESTS_CA_BUNDLE="$HOME/.certs/corp-ca-bundle.pem"   # Python/requests
export SSL_CERT_FILE="$HOME/.certs/corp-ca-bundle.pem"         # OpenSSL/curl
```

## 4. Validate

```sh
node -e "require('https').get('https://intranet.corp/', r => console.log(r.statusCode)).on('error', console.error)"
curl -I https://intranet.corp/
```

If certificate errors persist, make sure **all** intermediates were imported into the Keychain and included in the PEM bundle.
