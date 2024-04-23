#!/bin/bash

git clone https://github.com/aiortc/aioquic

cd aioquic

apt-get update && apt-get install pip -y

pip install wsproto aioquic starlette jinja2 dnslib

# Generate a new RSA private key of 4096 bits
openssl genrsa -out root_ca.key 4096

# Create a self-signed certificate for the root CA
openssl req -x509 -nodes -days 730 -newkey rsa:2048 -keyout cert.key -out cert.pem -config req.cnf -sha256

# server
python examples/http3_server.py --certificate cert.pem --private-key root_ca.key
