#!/bin/bash

# Generate a new RSA private key of 4096 bits
openssl genrsa -out root_ca.key 4096

# Create a self-signed certificate for the root CA
openssl req -new -x509 -sha256 -key root_ca.key -out root_ca.crt -days 3650 -subj "/"
