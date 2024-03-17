## How to run the tests **in the project's current state**

1. Clone the repo in each worker node and the CA.

```
git clone https://github.com/attia-mahmoud/nopasaran-tests
cd nopasaran-tests
```

2. Create the certificate in the CA.

```
chmod +x create_ca.sh
./create_ca.sh
```

3. Copy `root_ca.key` and `root_ca.crt` to each worker node.

4. Create the certificates and configuration files in each worker node.
```
chmod +x setup_worker.sh
./setup_worker.sh <endpoint_number> <IP of other worker> <server port>
```

5. Modify the variables in `variables.json` based on each worker's needs. 

6. Run the test scenario in each worker simultaneously.

```
nopasaran WORKER --scenario=MAIN.json --verbose --log-level=debug
```
