# bitcoin-node

This is a Bitcoin Node build and deployment. Aim to deploy a Bitcoin Node on into a Kubernetes cluster.

## Services

- Bitcoin Core Node
- Esplora API
- Mempool API (Only fee rate api) 

## Build Image (Local)

```shell
make build-images
```

Will build below images, defined in `docker/docker-compose.yaml`:
- bitlightlabs/bicoind:v28.0
- bitlightlabs/esplora-api-rln:v0.3.0

## Build Image (Release)

Build via github actions workflows, trigger by push tag:
- bitcoind-on-tag
- esplora-api-on-tag

Support arch: amd64, arm32, arm64
- [bitlightlabs/bitcoind](https://hub.docker.com/r/bitlightlabs/bitcoind)
- [bitlightlabs/esplora-api-rln](https://hub.docker.com/r/bitlightlabs/esplora-api-rln)

## Deploy Regtest Node (Local k8s/Docker Desktop)

1. Enable k8s in Docker desktop

2. Install nginx ingress

    ```shell
    make install-local-ingress
    ```

3. add a DNS record in hosts used as esplora services, for example:

   ```
   127.0.0.1 regtest.bitcoin-node.local
   ```
   
4. parepare helm values, **please change the mintAddress to your address
    
   ```
   # charts/local-regtest-values.yaml
   network: regtest
   bitcoind:
   mintInterval: 10
   mintAddress: "bcrt1pn0s2pajhsw38fnpgcj79w3kr3c0r89y3xyekjt8qaudje70g4shs20nwfx"

   ingress:
   enabled: true
   annotations:
   kubernetes.io/ingress.class: nginx
   hosts:
    - host: regtest.bitcoin-node.local
   paths:
    - path: /
   pathType: Prefix 
   ```
5. install bitcoin-node helm
    ```
    make deploy-local-regtest
    ```
6. check esplora api
   ```
   curl regtest.bitcoin-node.local/
   ```

## Remove Deployment (Local)

```shell
make delete-local-regtest
kubctl delete ns bitcoin-node-local
```