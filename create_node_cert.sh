#!/bin/bash

# Check if three arguments were provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <endpoint_number> <destination_ip> <server_port>"
    exit 1
fi

# Assign arguments to variables
NUMBER=$1
DESTINATION_IP=$2
SERVER_PORT=$3
ENDPOINT_NAME="endpoint${NUMBER}"

# Generate a new RSA private key of 2048 bits
openssl genrsa -out "${ENDPOINT_NAME}.key" 2048

# Create a certificate signing request (CSR), skipping optional fields
openssl req -new -sha256 -key "${ENDPOINT_NAME}.key" -out "${ENDPOINT_NAME}.csr" -subj "/C=SA/ST=Jeddah/L=Thuwal/O=NoPASARAN"

# Sign the CSR with the root CA to get the certificate
openssl x509 -req -sha256 -in "${ENDPOINT_NAME}.csr" -CA root_ca.crt -CAkey root_ca.key -CAcreateserial -out "${ENDPOINT_NAME}.crt" -days 365

# Combine the private key and certificate into a PEM file
cat "${ENDPOINT_NAME}.key" "${ENDPOINT_NAME}.crt" > "${ENDPOINT_NAME}.pem"

# Create the configuration file
cat > "conf_${ENDPOINT_NAME}.json" <<EOF
{
     "ROOT_CERTIFICATE": "root_ca.crt",
     "PRIVATE_CERTIFICATE": "${ENDPOINT_NAME}.pem",
     "DESTINATION_IP": "${DESTINATION_IP}",
     "SERVER_PORT": "${SERVER_PORT}"
}
EOF

echo "${ENDPOINT_NAME} key, certificate, PEM file, and configuration file have been created."
