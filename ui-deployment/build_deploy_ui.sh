#!/bin/bash

docker build --force-rm=true -t gwas-deposition-ui:latest .
docker tag gwas-deposition-ui:latest ebispot/gwas-deposition-ui:latest-sandbox
docker push ebispot/gwas-deposition-ui:latest-sandbox

kubectl delete deploy gwas-deposition-ui
kubectl create -f gwas-deposition-ui-deployment.yaml
