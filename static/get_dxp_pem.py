import json
import os
import requests
from cryptography.hazmat.primitives.asymmetric import rsa
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.backends import default_backend
import base64

def get_jwks(jwks_url):
    response = requests.get(jwks_url)
    return response.json()

def jwk_to_pem(jwk):
    modulus_b64 = jwk['n']
    exponent_b64 = jwk['e']

    modulus = int.from_bytes(base64.urlsafe_b64decode(modulus_b64 + '=='), 'big')
    exponent = int.from_bytes(base64.urlsafe_b64decode(exponent_b64 + '=='), 'big')

    public_numbers = rsa.RSAPublicNumbers(exponent, modulus)
    public_key = public_numbers.public_key(default_backend())

    pem = public_key.public_bytes(
        encoding=serialization.Encoding.PEM,
        format=serialization.PublicFormat.SubjectPublicKeyInfo
    )
    return pem.decode('utf-8')

def main():
    jwks_url = os.getenv('LIFERAY_DXP_URL') + "/o/oauth2/jwks"
    if not jwks_url:
        print("Environment variable LIFERAY_DXP_URL is not set")
        return

    jwks = get_jwks(jwks_url)
    pem = ""

    for key in jwks['keys']:
        pem = jwk_to_pem(key)
        break  # Assuming you only need the first key

    # Remove the BEGIN and END tags and any surrounding whitespace, then remove line breaks
    pem_body = pem.replace("-----BEGIN PUBLIC KEY-----", "").replace("-----END PUBLIC KEY-----", "").replace("\n", "").strip()
    print(pem_body)

if __name__ == "__main__":
    main()
