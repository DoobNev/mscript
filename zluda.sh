#!/bin/bash

# Update and install prerequisites
sudo apt update && sudo apt install -y git cmake python3 rustc cargo

# Optional but recommended: Install Ninja
sudo apt install -y ninja-build

# Install ROCm
sudo apt install -y rocm-dev

# Clone the ZLUDA repository
git clone --recurse-submodules https://github.com/vosen/zluda.git
cd zluda

# Build ZLUDA
cargo xtask --release

# Set up environment variables (modify according to your setup if necessary)
echo "export LD_LIBRARY_PATH=$(pwd)/target/release:\$LD_LIBRARY_PATH" >> ~/.bashrc

# Reload .bashrc to apply changes
source ~/.bashrc

# Usage instructions printed to the console
echo "ZLUDA has been installed. To use it, prepend the LD_LIBRARY_PATH when running your applications:"
echo "LD_LIBRARY_PATH=\$LD_LIBRARY_PATH <APPLICATION> <APPLICATION_ARGUMENTS>"

