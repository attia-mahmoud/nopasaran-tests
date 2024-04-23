#!/bin/bash

# git clone https://github.com/aiortc/aioquic

# apt-get update && apt-get install pip -y

# pip install wsproto aioquic starlette jinja2 dnslib

# # Create a self-signed certificate
openssl req -x509 -nodes -days 730 -newkey rsa:2048 -keyout cert.key -out cert.pem -config req.cnf -sha256

pip install hypercorn[h3] quart
