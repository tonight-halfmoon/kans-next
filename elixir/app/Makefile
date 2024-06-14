.PHONY: help

help:
	@perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[37;2;1m%-17s\033[32;m %s\n", $$1, $$2}'

port := 4000

ifndef MIX_ENV
$(error Expected MIX ENV to be set)
endif

# ifeq ($(MIX_ENV),)
# 	$(error Expected MIX_ENV to be set!)
# endif

ifeq ($(MIX_ENV), dev)
	port := 4001
else
	port := 4000
endif

source_rev := $(shell tr -d '\n' <./VERSION)

export

install: ## Run the initial setup; i.e, install mix dependencies, etc... *(local)
	MIX_ENV=$(MIX_ENV) mix "do" \
		local.hex --force
		+ deps.get \
		+ deps.compile \
		+ compile

release_init: ## Generate rel/ VM.args and env
	MIX_ENV=$(MIX_ENV) mix release.init

phx_release_gen: ## Generate release files
	MIX_ENV=$(MIX_ENV) mix "do" \
		deps.get \
		+ phx.gen.release

release: ## Make a release

server: ## Start the web server *(local)
	MIX_ENV=$(MIX_ENV) mix phx.server

ecto_setup: ## Set up database with Ecto and run mix ecto.{create,migrate} *(local)
	createuser ci_dev
	createdb kans_dev --owner=ci_dev --username=ci_dev
	pg_ctl start
	MIX_ENV=$(MIX_ENV) mix "do" \
		ecto.create \
		+ ecto.migrate

testing: ## Run tests *(local)
ifeq ($(MIX_ENV), test)
	MIX_ENV=$(MIX_ENV) mix "do" \
		deps.get \
		+ deps.compile \
		+ compile \
		+ ecto.create --quiet \
		+ ecto.migrate --quiet \
		+ test --seed 87234
else
	$(error Expected MIX_ENV to be set with value test!)
endif

image_build: ## Build an image for the server (docker)
ifeq ($(MIX_ENV), test)
	$(error Use a different task for tests or change MIX_ENV to dev!)
else
	docker build \
		--build-arg parameter_mix_env=$(MIX_ENV) \
		--label kans.source_revision=$(source_rev) \
		--tag kans-elixir-lv-$(MIX_ENV):$(source_rev) \
		--file Dockerfile.alpine \
		--progress=plain \
		.
endif

container_run: ## Start the server on a container (docker)
ifeq ($(MIX_ENV), test)
	$(error We do not run a server during test!)
else
	docker run --name kans-elixir-lv-$(MIX_ENV) \
		--mount=type=bind,source=/etc/tls,target=/etc/tls,ro \
		--mount=type=bind,source=/etc/ssl/certs/ca.crt,target=/etc/ssl/certs/ca.crt,ro \
		--publish $(port):$(port) \
		--label kans.source_revision=$(source_rev) \
		--network kans-net \
		kans-elixir-lv-$(MIX_ENV):$(source_rev)
endif

postgres: ## Start a postgres server instance on a container (docker)
	docker run --name postgres \
		-e POSTGRES_PASSWORD=ci_dev -e POSTGRES_USER=ci_dev -e POSTGRES_DB=kans_$(MIX_ENV) \
		--network=kans-net \
		--detach postgres

postgres_ci_testing: ## Start a postgres server instance for CI testing on a container (docker)
	docker run --name postgres-ci-testing \
		-e POSTGRES_PASSWORD=ci_test -e POSTGRES_USER=ci_test -e POSTGRES_DB=kans_$(MIX_ENV) \
		--network=kans-net \
		--detach postgres

network_create: ## Create a network (docker)
	docker network create \
		--driver=bridge \
		--subnet=172.28.0.0/16 \
		--ip-range=172.28.5.0/29 \
		--gateway=172.28.5.254 \
		kans-net

network_connect: ## Connect containers to the network (docker)
	@docker network connect kans-net postgres | true
	@docker network connect kans-net postgres-ci-testing | true
	@docker network connect kans-net kans-elixir-lv-$(MIX_ENV) | true

network_destroy: ## Delete the network (docker)
	@docker network disconnect kans-net kans-elixir-lv | true
	@docker network disconnect kans-net postgres | true
	@docker network rm kans-net
	@docker network rm kans-net

container_cleanup: ## Stop and delete the containers (docker)
	@docker stop kans-elixir-lv | true
	@docker stop postgres || true
	@docker stop postgres-ci-testing || true
	@docker rm kans-elixir-lv | true
	@docker rm postgres || true
	@docker rm postgres-ci-testing || true

image_cleanup: ## Delete the images (docker)
	@docker image rm $(shell docker image ls --filter dangling=true --format {{.ID}}) | true
	@docker image rm $(shell docker image ls --filter label=kans.source_revision=$(source_rev) --format {{.ID}}) | true
#	docker image rm postgres

image_build_ci_testing: ## Build an image to run tests (docker)
ifeq ($(MIX_ENV), test)
	docker build \
		--label kans.source_revision=$(source_rev) \
		--tag kans-elixir-lv-$(MIX_ENV):$(source_rev) \
		--file Dockerfile.alpine.test \
		.
else
	$(error Expected MIX_ENV to be 'test'!)
endif

container_run_ci_testing: ## Run tests on a container (docker)
ifeq ($(MIX_ENV), test)
	docker run --rm --name kans-elixir-lv-$(MIX_ENV) \
		--label kans.source_revision=$(source_rev) \
		--network=kans-net \
		kans-elixir-lv-$(MIX_ENV):$(source_rev)
else
	$(error Expected MIX_ENV to be 'test'!)
endif
