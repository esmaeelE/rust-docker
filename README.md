# rust-docker
Dockerize Rust hello world


## Run

build

```bash
podman build -t rust-hello .
```

run

```bash
$ podman run --rm localhost/rust-hello:latest 
Hello, world!
```
