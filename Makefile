NAME = carbonfive/base
VERSION = 0.0.1

.PHONY: all build_all \
	build_customizable build_ruby21 \
	build_nodejs build_full \
	tag_latest release clean

all: build_all

build_all: build_customizable build_ruby21 build_nodejs build_full

# Docker doesn't support sharing files between different Dockerfiles. -_-
# So we copy things around.
build_customizable:
	rm -rf customizable_image
	cp -pR image customizable_image
	docker build -t $(NAME)-customizable:$(VERSION) --rm customizable_image

build_ruby21:
	rm -rf ruby21_image
	cp -pR image ruby21_image
	echo ruby21=1 >> ruby21_image/buildconfig
	echo final=1 >> ruby21_image/buildconfig
	docker build -t $(NAME)-ruby21:$(VERSION) --rm ruby21_image

build_nodejs:
	rm -rf nodejs_image
	cp -pR image nodejs_image
	echo nodejs=1 >> nodejs_image/buildconfig
	echo final=1 >> nodejs_image/buildconfig
	docker build -t $(NAME)-nodejs:$(VERSION) --rm nodejs_image

build_full:
	rm -rf full_image
	cp -pR image full_image
	echo ruby21=1 >> full_image/buildconfig
	echo nodejs=1 >> full_image/buildconfig
	echo redis=1 >> full_image/buildconfig
	echo memcached=1 >> full_image/buildconfig
	echo final=1 >> full_image/buildconfig
	echo postgresql=1 >> full_image/buildconfig
	echo unicorn=1 >> full_image/buildconfig
	docker build -t $(NAME)-full:$(VERSION) --rm full_image

tag_latest:
	docker tag $(NAME)-customizable:$(VERSION) $(NAME)-customizable:latest
	docker tag $(NAME)-ruby21:$(VERSION) $(NAME)-ruby21:latest
	docker tag $(NAME)-nodejs:$(VERSION) $(NAME)-nodejs:latest
	docker tag $(NAME)-full:$(VERSION) $(NAME)-full:latest

release: tag_latest
	@if ! docker images $(NAME)-customizable | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)-customizable version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)-ruby18 | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)-ruby18 version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)-ruby19 | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)-ruby19 version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)-ruby20 | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)-ruby20 version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)-ruby21 | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)-ruby21 version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)-nodejs | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)-nodejs version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)-full | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)-full version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	docker push $(NAME)-customizable
	docker push $(NAME)-ruby21
	docker push $(NAME)-nodejs
	docker push $(NAME)-full
	@echo "*** Don't forget to create a tag. git tag rel-$(VERSION) && git push origin rel-$(VERSION)"

clean:
	rm -rf customizable_image
	rm -rf ruby21_image
	rm -rf nodejs_image
	rm -rf full_image
