# NOTE: make help uses a special comment format to group targets.
# If you'd like your target to show up use the following:
#
# my_target: ##@category_name sample description for my_target

default: help

#gcp_project = "nomad-prod-193619"
#docker_image_name = "gcr.io/${gcp_project}/nomad-flask:master-230ecdc-SNAPSHOT"
#api_spec_url = "/api/open-api-spec/"
#redoc_version = "2.0.0-rc.18"
#version ?= "v1"

.PHONY: start install pre-install start stop loki

pre-install: ##@prometheus_grafana_loki Installs prerequisite software
	$(info ********** Installing Prerequisites **********)
	@if [[ -z "$(command -v brew)" ]]; then /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; fi
	@brew update && brew bundle

install: ##@prometheus_grafana_loki Installs needed prerequisites and softwared
	$(info ********** Installing Prometheus/Grafana on Kubernetes **********)
	@echo "Please install the Google Cloud CLI from the documentation located here --> https://cloud.google.com/sdk/docs/install"
	@make delete
	@cd scripts || exit 1 && bash repo_additions.sh
	@cd scripts || exit 1 && bash install.sh
	@make loki
	@cd scripts || exit 1 && bash minikube.sh

loki: ##@prometheus_grafana_loki Installs Loki to the k8s cluster
	$(info ********** Installing Loki Log Aggregation **********)
	@helm install loki-stack grafana/loki-stack --values loki/loki-stack-values.yaml
	#-n loki --create-namespace

start: ##@prometheus_grafana_loki starts Prometheus/Grafana services on Kubernetes
	$(info ********** Start Prometheus/Grafana Services **********)
	minikube start

stop: ##@prometheus_grafana_loki stops Prometheus/Grafana services on Kubernetes
	$(info ********** Stop Prometheus/Grafana Services **********)
	minikube stop

delete: ##@prometheus_grafana_loki deletes Prometheus/Grafana services on Kubernetes
	$(info ********** Delete Prometheus/Grafana Services Kubernetes Cluster **********)
	minikube delete

help: ##@miscellaneous Show this help.
	@echo $(MAKEFILE_LIST)
	@perl -e '$(HELP_FUNC)' $(MAKEFILE_LIST)

# helper function for printing target annotations
# ripped from https://gist.github.com/prwhite/8168133
HELP_FUNC = \
	%help; \
	while(<>) { \
		if(/^([a-z0-9_-]+):.*\#\#(?:@(\w+))?\s(.*)$$/) { \
			push(@{$$help{$$2}}, [$$1, $$3]); \
		} \
	}; \
	print "usage: make [target]\n\n"; \
	for ( sort keys %help ) { \
		print "$$_:\n"; \
		printf("  %-20s %s\n", $$_->[0], $$_->[1]) for @{$$help{$$_}}; \
		print "\n"; \
	}
