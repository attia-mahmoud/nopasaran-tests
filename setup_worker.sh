#!/bin/bash

# Check if three arguments were provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <endpoint_number> <destination_ip> <server_port>"
    exit 1
fi

apt-get update && apt-get install tcpdump

# Assign arguments to variables
NUMBER=$1
DESTINATION_IP=$2
SERVER_PORT=$3
ENDPOINT_NAME="endpoint${NUMBER}"

# Add root_ca.crt to root store
cp root_ca.crt /usr/local/share/ca-certificates
update-ca-certificates

# Generate a new RSA private key of 2048 bits
openssl genrsa -out "${ENDPOINT_NAME}.key" 2048

# Create a certificate signing request (CSR), skipping optional fields
openssl req -new -sha256 -key "${ENDPOINT_NAME}.key" -out "${ENDPOINT_NAME}.csr" -subj "/"

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

# Create the variables file
cat > "variables.json" <<EOF
{
  "ttl": 1,
  "ip_dst": "${DESTINATION_IP}",
  "icmp_filter": "icmp",
  "udp_filter": "udp",
  "role": "client",
  "controller_conf_filename": "conf_${ENDPOINT_NAME}.json"
}
EOF

echo "${ENDPOINT_NAME} key, certificate, PEM file, configuration file, and variables file have been created."
