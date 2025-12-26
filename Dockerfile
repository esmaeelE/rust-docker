# ---------- Build stage ----------
# Use the slim Rust image (Debian-based) to compile the application
FROM rust:1.92-slim AS builder

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy Cargo manifests first (better Docker cache usage)
COPY Cargo.toml Cargo.lock ./

# Copy the actual application source code
COPY src ./src

# Build the final application binary in release mode
RUN cargo build --release

# ---------- Runtime stage ----------
# Use a minimal Debian image compatible with glibc
FROM debian:trixie-slim

# Set working directory
WORKDIR /app

# Copy the compiled binary from the builder stage
COPY --from=builder /usr/src/app/target/release/hello_rust .

# Run the compiled Rust binary
CMD ["./hello_rust"]

