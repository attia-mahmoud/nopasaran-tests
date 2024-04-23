#!/bin/bash

git clone https://github.com/aiortc/aioquic

cd aioquic

apt-get update && apt-get install pip -y

pip install wsproto aioquic starlette jinja2 dnslib

# server
python examples/http3_server.py --certificate tests/ssl_cert.pem --private-key tests/ssl_key.pem

# Generate a new RSA private key of 4096 bits
openssl genrsa -out root_ca.key 4096

# Create a self-signed certificate for the root CA
openssl req -new -x509 -sha256 -key root_ca.key -out root_ca.crt -days 3650 -subj "/"
