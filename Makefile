PWD = $(shell pwd)
NS = bitcoin-node-local

.PHONY: check-env
check-env:
	source .env && env | grep NETWORK
	# source .env && ./scripts/env.sh

.PHONY: build-images
build-images:
	@echo "Building images..."
	cd docker && docker compose build

install-local-ingress:
	helm upgrade --install ingress-nginx ingress-nginx \
  		--repo https://kubernetes.github.io/ingress-nginx \
  		--namespace ingress-nginx --create-namespace

deploy-local-regtest:
	helm -n $(NS) upgrade regtest ./charts/bitcoin-node \
	--install \
	--values ./charts/local-regtest-values.yaml \
	--create-namespace

delete-local-regtest:
	helm -n $(NS) uninstall regtest

deploy-local-testnet3:
	helm -n $(NS) upgrade testnet3 ./charts/bitcoin-node \
	--install \
	--values ./charts/local-testnet3-values.yaml \
	--create-namespace

template-local-regtest:
	helm -n $(NS) template regtest ./charts/bitcoin-node --values ./charts/local-regtest-values.yaml > template.yaml

debug-local-regtest:
	kubectl run -n $(NS) -i --tty --rm debug --image=curlimages/curl  --restart=Never -- sh