## How to run the tests IN THE PROJECT'S CURRENT STATE

1. Clone the repo in each worker node and the CA.

```
git clone https://github.com/attia-mahmoud/nopasaran-tests
cd nopasaran-tests
```

2. Create the certificates and configuration files in each worker node.
```
chmod +x setup_worker.sh
./setup_worker.sh <endpoint_number> <IP of other worker> <server port>
```

3. Modify the variables in `variables.json` based on each worker's needs. 

4. Run the test scenario in each worker simultaneously.

```
nopasaran WORKER --scenario=MAIN.json --verbose --log-level=debug
```
