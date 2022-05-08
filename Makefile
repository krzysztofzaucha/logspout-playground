.PHONY: mariadb

export SHELL:=/bin/bash
export BASE_NAME:=$(shell basename ${PWD})
export IMAGE_BASE_NAME:=kz/$(shell basename ${PWD})
export NETWORK:=${BASE_NAME}-network

default: help

help: ## Prints help for targets with comments
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' ${MAKEFILE_LIST} | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-50s\033[0m %s\n", $$1, $$2}'
	@echo ""

#######
# Run #
#######

compose:
	@podman-compose ${COMPOSE} \
		-p ${BASE_NAME} \
		up -d --build --force-recreate --remove-orphans --abort-on-container-exit

up-logspout-papertrail: ## Start the Logspout with Papertrail example
	@COMPOSE=" -f docker-compose.yml -f logspout-papertrail.yml" make compose

up-logspout-grouping-papertrail: ## Start the Logspout grouping with Papertrail example
	@COMPOSE=" -f docker-compose.yml -f logspout-grouping-papertrail.yml" make compose

###############
# Danger Zone #
###############

reset: ## Cleanup
	@podman stop $(shell podman ps -aq)
	@podman system prune
	@podman volume rm $(shell podman volume ls -q)
	@podman rmi -f ${IMAGE_BASE_NAME}-ping:latest
