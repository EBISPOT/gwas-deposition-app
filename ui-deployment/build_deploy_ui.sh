#!/bin/bash

docker build --force-rm=true -t gwas-deposition-ui:latest .
docker tag gwas-deposition-ui:latest ebispot/gwas-deposition-ui:latest-sandbox
docker push ebispot/gwas-deposition-ui:latest-sandbox

kubectl --kubeconfig ~/.kube/gwas-depo-embassy-dev-config.yml delete deploy gwas-deposition-ui -n gwas
kubectl --kubeconfig ~/.kube/gwas-depo-embassy-dev-config.yml apply -f gwas-deposition-ui-deployment.yaml
