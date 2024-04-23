#!/bin/bash

git clone https://github.com/aiortc/aioquic

cd aioquic

apt-get update && apt-get install pip -y

pip install wsproto aioquic starlette jinja2 dnslib

# server
python examples/http3_server.py --certificate tests/ssl_cert.pem --private-key tests/ssl_key.pem

