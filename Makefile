IMAGE_NAME=ambersun1234/issue-assign-all-collaborators:1.0

RED=\033[31m
GREEN=\033[32m
YELLOW=\033[33m
NC=\033[0m

image:
	docker build -t $(IMAGE_NAME) . --no-cache
	@echo -e "$(GREEN)Docker image sha256 is $(shell docker inspect --format='{{index .RepoDigests 0}}' $(IMAGE_NAME) | cut -d ':' -f 2)"

login:
	docker login -u ambersun1234
	@echo -e "$(YELLOW)[WARNING] You should logout after you finished your job$(NC)"

logout:
	docker logout

push:
	docker push $(IMAGE_NAME)