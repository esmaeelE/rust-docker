IMAGE_NAME := rust-hello
CONTAINER_ENGINE := podman

.PHONY: build build-release lint fmt test clean docker-build docker-run

# --- Local ---

build:
	cargo build

build-release:
	cargo build --release

lint:
	cargo clippy -- -D warnings
	cargo fmt --check

fmt:
	cargo fmt

test:
	cargo test

clean:
	cargo clean

# --- Docker ---

docker-build:
	$(CONTAINER_ENGINE) build -t $(IMAGE_NAME) .

docker-run:
	$(CONTAINER_ENGINE) run --rm localhost/$(IMAGE_NAME):latest