# Simple Cache Microservice

2. run `docker build -t cacheservice:latest -f production.dockerfile .`
3. push it to registry
4. spin up some Redis in cloud such as Memorystore
5. Create a k8s deployment & service for this app and provide list of env vars:
  - REDIS_HOST
  - REDIS_PORT
  - REDIS_DB

# Building Docker image and Helm Chart

```shell
make build-image
make push-image
make build-chart
make publish-chart
```

# Installing application to Kubernetes

```shell
make install-microk8s
```
