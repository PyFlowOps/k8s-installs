shell = ${SHELL}

# Meta-Goals
.PHONY: help
.DEFAULT_GOAL := help
project := pfo

default:
	echo 'Makefile default target!'

hook:
	$(info ******** Installing Githooks ********)
	git config core.hooksPath .githooks

unhook:
	$(info ******** Uninstalling Githooks ********)
	git config --unset core.hooksPath

##@ Section 1: Local Build Commands
pfo-local-dev: ## Builds the PyFlowOps application within a virtual Python environment (locally)
	$(info ******** Installing PyFlowOps via Local Installation ********)
	#@source ~/.pfo/.env
	#@echo "Installing pfo Ecosystem local Python environment"
	@echo "Under Construction"

.PHONY: k8s-pfo-create k8s-pfo-update k8s-pfo-remove kubectl-database-init pfo-docker-image-dev pfo-docker-image-prod rabbitmq-consumer-docker-image

##@ Section 2: Kubernetes Cluster Commands
kube-pfo-create: ## Builds the PyFlowOps application within a Kubernetes environment (locally)
	$(info ******** Installing pfo Kubernetes Cluster in Kind ********)
	#@make kubectl-database-init
	@cd deploy || exit 1 && sh start_cluster.sh local

kube-pfo-update: ## Updates the PyFlowOps application within a Kubernetes environment (locally)
	$(info ******** Updating PyFlowOps Kubernetes Cluster in Kind ********)
	@cd deploy || exit 1 && sh update_cluster.sh local
	@kubectl config set-context --current --namespace=local
	#@kubectl apply -f deploy/local/pfo/pfo-deployment.yaml
	@cd deploy || exit 1 && sh start_cluster.sh local
	@echo "Under Construction"

kube-pfo-remove: ## Removes the PyFlowOps application within a Kubernetes environment (locally)
	$(info ******** Removing PyFlowOps Kubernetes Cluster in Kind ********)
	#cd deploy || exit 1 && sh delete_local_cluster.sh pfo-local
	@echo "Under Construction"

kubectl-database-init:
	$(info ******** Running the Database Initialization ********)
	#@bash scripts/local_k8s/database-init.sh
	@echo "Under Construction"

##@ Section 3: Dockerfile Build Commands
pfo-docker-image-dev: ## Builds the PyFlowOps Core application within a Docker container
	$(info ******** Building Core Development Docker Image ********)
	#@@docker build -f unitytree_core/Dockerfile.dev -t unitytree/core:latest .
	@echo "Under Construction"

pfo-docker-image-prod: ## Builds the pfo Core application within a Docker container
	$(info ******** Building Core Production Docker Image ********)
	#@docker build -f pfo/Dockerfile.prod -t pfo:latest .
	@echo "Under Construction"

rabbitmq-consumer-docker-image: ## Builds the PyFlowOps RabbitMQ Consumer application within a Docker container
	$(info ******** Building RabbitMQ Consumer Docker Image ********)
	#@git clone git@github.com:PyFlowOps/PyFlowOps-RabbitMQ.git rabbitmq-consumer
	#@cd rabbitmq-consumer || exit 1 && docker build --file Dockerfile.consumer -t pfo/rabbitmq-consumer:latest .
	@echo "Under Construction"

### Help Section
help:
	@awk 'BEGIN {FS = ":.*##"; printf "Usage: make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
