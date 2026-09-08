# rust-docker

Dockerized Rust hello-world with multi-stage Docker build.

## Prerequisites

- [Rust](https://www.rust-lang.org/tools/install) (for local development)
- [Podman](https://podman.io/) or [Docker](https://www.docker.com/) (for building/running the container)

## Run

Build the image:

```bash
podman build -t rust-hello .
```

Run the container:

```bash
podman run --rm localhost/rust-hello:latest
```

Expected output:

```
Hello, world!
```

## Makefile

Quick commands via `make`:

| Command | Description |
|---------|-------------|
| `make build` | Local debug build |
| `make build-release` | Local release build |
| `make lint` | Run clippy + fmt check |
| `make fmt` | Auto-format code |
| `make test` | Run tests |
| `make clean` | Remove build artifacts |
| `make docker-build` | Build container image |
| `make docker-run` | Run container |

Switch to Docker by setting `CONTAINER_ENGINE=docker`.

## How it works

The `Dockerfile` uses a **multi-stage build** to keep the final image small:

### Stage 1 — Builder (`rust:1.92-slim`)

1. Copies `Cargo.toml` + `Cargo.lock` and a dummy `main.rs`, then runs `cargo build --release`.
   This compiles all **dependencies** and caches them in the Docker layer.
2. Removes the dummy source, copies the real `src/`, and rebuilds.
   Only the **app code** recompiles — dependencies stay cached across rebuilds.

### Stage 2 — Runtime (`debian:trixie-slim`)

1. Copies **only the compiled binary** from the builder stage.
2. Creates a non-root `app` user (uid 1000) for security.
3. Runs the binary as that user.

Result: final image contains only the binary + minimal Debian runtime (~80MB), not the full Rust toolchain (~1.5GB).
