FROM ubuntu:24.04

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    python3 \
    python3-venv \
    python3-pip \
    ssh \
    sudo \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Create a virtual environment for Ansible
RUN python3 -m venv /opt/ansible-venv

# Upgrade pip inside venv and install Ansible
RUN /opt/ansible-venv/bin/pip install --upgrade pip ansible

# Add virtual environment to PATH
ENV PATH="/opt/ansible-venv/bin:$PATH"

# Set working directory
WORKDIR /ansible

# Default command
CMD ["bash"]
