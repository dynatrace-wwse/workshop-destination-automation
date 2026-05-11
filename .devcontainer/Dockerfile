FROM mcr.microsoft.com/devcontainers/base:debian

# Install prerequisites
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    jq \
    && rm -rf /var/lib/apt/lists/*

# Copy and trust the AAP certificate
COPY aap-cert.cert /usr/local/share/ca-certificates/aap-cert.crt
RUN update-ca-certificates

# Create symlink for NODE_EXTRA_CA_CERTS environment variable (only if it doesn't exist)
RUN ln -sf /usr/local/share/ca-certificates/aap-cert.crt /etc/ssl/certs/aap-cert.pem

# Install dtctl CLI for Dynatrace operations
RUN ARCH=$(uname -m | sed 's/x86_64/amd64/; s/aarch64/arm64/') && \
    OS=$(uname -s | tr '[:upper:]' '[:lower:]') && \
    TAG=$(curl -s -I -L https://github.com/dynatrace-oss/dtctl/releases/latest | tr -d '\r' | awk -F/ '/^location: /{print $NF}' | tail -n1) && \
    TARBALL="dtctl_${TAG#v}_${OS}_${ARCH}.tar.gz" && \
    URL="https://github.com/dynatrace-oss/dtctl/releases/download/${TAG}/${TARBALL}" && \
    mkdir -p /tmp/dtctl && cd /tmp/dtctl && \
    curl -L "$URL" -o "$TARBALL" && \
    tar -xzf "$TARBALL" && \
    mv dtctl /usr/local/bin/ && \
    chmod +x /usr/local/bin/dtctl && \
    rm -rf /tmp/dtctl

# Verify installations
RUN dtctl version && \
    openssl version && \
    jq --version

# Set working directory
WORKDIR /workspaces/workshop-destination-automation
