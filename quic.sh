#!/bin/bash

# Install necessary packages
apt-get update
apt-get install -y pkg-config libssl-dev git curl build-essential cmake

# Install Rust
curl https://sh.rustup.rs -sSf | sh

# Clone quiche and build examples
git clone --recursive https://github.com/cloudflare/quiche
cd quiche
cargo build --examples

# Check if an IP address is provided as the first argument
if [ "$#" -eq 1 ]; then
    # If an IP address is provided, run the http3-client with the provided IP address
    ./target/release/examples/http3-client https://$1:4433/
else
    # If no IP address is provided, generate a self-signed certificate and run the http3-server
    openssl req -x509 -newkey rsa:4096 -keyout my_key.key -out my_cert.crt -days 365 -nodes
    ./target/release/examples/http3-server . 0.0.0.0:4433 --cert my_cert.crt --key my_key.key
fi
