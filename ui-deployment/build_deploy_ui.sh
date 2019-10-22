#!/bin/bash

docker build --force-rm=true -t gwas-deposition-ui:latest .
docker tag gwas-deposition-ui:latest ebispot/gwas-deposition-ui:latest-sandbox
docker push ebispot/gwas-deposition-ui:latest-sandbox

kubectl --kubeconfig ~/.kube/gwas-depo-embassy-dev-config.yml delete -f gwas-deposition-ui-deployment.yaml
kubectl --kubeconfig ~/.kube/gwas-depo-embassy-dev-config.yml create -f gwas-deposition-ui-deployment.yaml
