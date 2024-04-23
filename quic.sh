#!/bin/bash

git clone https://github.com/aiortc/aioquic

cd aioquic

apt-get update && apt-get install pip -y

pip install wsproto aioquic starlette jinja2 dnslib

# Create a self-signed certificate for the root CA
openssl req -x509 -nodes -days 730 -newkey rsa:2048 -keyout cert.key -out cert.pem -config req.cnf -sha256

# server
python3 examples/http3_server.py --certificate cert.pem --private-key cert.key

# client
python3 examples/http3_client.py https://192.168.122.2:4433 --insecure
