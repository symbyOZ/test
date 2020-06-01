# Docker images
## Authorize in ECR
```shell
$(aws ecr get-login --no-include-email)
```

## Build and upload images to ECR
```shell
make build-all-images
make publish-all-images
```

# Helm Chart for Kubernetes deployment
## Add S3 plugin for Helm
This project uses S3 bucket for publishing its charts.
To be able your helm installation to work with S3 repositories you need to install plugin:
``` shell
helm plugin install https://github.com/hypnoglow/helm-s3.git
```

## Add Bitnami repository to Helm
```shell
helm repo add bitnami https://charts.bitnami.com/
helm repo update
```

## Build chart
```shell
make build-chart
```

## Publish chart to a project repository in S3
```shell
make publish-chart
```

## Install jaeger-rd chart locally in microk8s
You must have microk8s as a default context in your $KUBECONFIG. This command only provides 'helm upgrade --install' with values tweaked for microk8s.
```shell
make install-microk8s
```

## Install jaeger-rd chart in EKS cluster
You must have EKS as a default context in your KUBECONFIG. This command only provides 'helm upgrade --install' with values tweaked for EKS.
```shell
make install-eks
```

## Uninstall chart
```shell
make uninstall
```
