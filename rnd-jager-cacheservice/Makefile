APP_NAME=cacheservice
VERSION=$(shell cat VERSION)
ECR_URL=589295909756.dkr.ecr.us-east-2.amazonaws.com/${APP_NAME}
CHARTS_REPO_NAME=helm-rnd-charts

CHART=cacheservice

.PHONY: all clean
all: build-image publish-image build-chart publish-chart

build-image:
	@echo "+ $@"
	docker build -t ${ECR_URL}:${VERSION} -f production.dockerfile .

publish-image: build-image
	@echo "+ $@"
	docker push ${ECR_URL}:${VERSION}

build-chart:
	@echo "+ $@"
	cd helm-charts && \
	helm lint ${CHART} && \
	helm dependency build ${CHART} && \
	helm package --app-version "${VERSION}" --version "${VERSION}" "${CHART}"

publish-chart: build-chart
	@echo "+ $@"
	helm s3 push --force helm-charts/${CHART}-${VERSION}.tgz ${CHARTS_REPO_NAME}

install-microk8s:
	@echo "+ $@"
	helm repo update && \
	helm upgrade \
		--install \
		--values helm-charts/${CHART}-microk8s-values.yaml \
		--version ${VERSION} \
		${CHART} \
		${CHARTS_REPO_NAME}/${CHART}

install-eks:
	@echo "+ $@"
	helm repo update && \
	helm upgrade \
		--install \
		--version ${VERSION} \
		${CHART} \
		${CHARTS_REPO_NAME}/${CHART}

uninstall:
	@echo "+ $@"
	helm uninstall ${CHART}

clean:
	@echo "+ $@"
	cd helm-charts && \
	rm -fv *.tgz
