IMAGE_NAME=ncbi/edirect

.PHONY: help image geo-search gap-search edirect

all: geo-search gap-search 

help: ## This prints help text for all the existing commands
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%25s:\033[0m %s\n", $$1, $$2}'

image: ## builds docker image
	(cd dockerbuild; ./build-image.sh)

geo-search: ## Searches GEO
	docker run --rm -v $$PWD:/work -w /work -e NCBI_API_KEY=$$NCBI_API_KEY -it ncbi/edirect bash -c /work/geo-pipeline.sh

gap-search: ## Searches dbGaP
	docker run --rm -v $$PWD:/work -w /work -e NCBI_API_KEY=$$NCBI_API_KEY -it ncbi/edirect bash -c /work/gap-pipeline.sh

edirect: ## Provides a shell to manually run edirect and XML utilities
	docker run --rm -v $$PWD:/work -w /work -e NCBI_API_KEY=$$NCBI_API_KEY -it ncbi/edirect bash