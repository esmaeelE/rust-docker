# ---------- Build stage ----------
FROM rust:1.92-slim AS builder

WORKDIR /usr/src/app

# Copy manifests + dummy src for dep caching
COPY Cargo.toml Cargo.lock ./
RUN mkdir src && echo 'fn main() { println!("placeholder"); }' > src/main.rs
RUN cargo build --release && rm -rf src target/release/hello_rust target/release/deps/hello_rust*

# Copy real source and rebuild only the app
COPY src ./src
RUN cargo build --release

# ---------- Runtime stage ----------
FROM debian:trixie-slim

# Run as non-root
RUN groupadd --gid 1000 app && useradd --uid 1000 --gid app --shell /bin/false app

WORKDIR /app

COPY --from=builder /usr/src/app/target/release/hello_rust ./

RUN chown app:app ./hello_rust

USER app

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD ["./hello_rust"]

CMD ["./hello_rust"]

