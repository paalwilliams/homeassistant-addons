#!/usr/bin/env python3
"""Generate an RS256 JWK keypair for wger.

This mirrors wger's own `manage.py generate-jwt-keys`, but without importing
Django. Loading the settings pulls in the full app registry, which is not
something we want to do during add-on startup, before the database and redis
are necessarily reachable.
"""

# Standard Library
import json
from base64 import urlsafe_b64encode

# Third Party
from cryptography.hazmat.primitives.asymmetric import rsa
from jwt.algorithms import RSAAlgorithm


private_jwk = json.loads(
    RSAAlgorithm.to_jwk(rsa.generate_private_key(public_exponent=65537, key_size=2048))
)
private_jwk['alg'] = 'RS256'
private_jwk['kid'] = 'wger'

public_jwk = {key: private_jwk[key] for key in ('kty', 'n', 'e', 'alg', 'kid')}


def b64_jwk(jwk):
    return urlsafe_b64encode(json.dumps(jwk).encode()).decode()


print(f'JWT_PRIVATE_KEY={b64_jwk(private_jwk)}')
print(f'JWT_PUBLIC_KEY={b64_jwk(public_jwk)}')
