#!/bin/bash

# Exit script if any command fails
set -e

# Update the system packages
sudo apt update

# Suspend needrestart and run upgrades non-interactively
export NEEDRESTART_SUSPEND=1
sudo DEBIAN_FRONTEND=noninteractive apt-get install -yq git tmux
sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -yq

# Install Rust via rustup with no user interaction
curl --proto '=https' --tlsv1.3 https://sh.rustup.rs -sSf | sh -s -- -y

# Ensure the Cargo environment is set up
source $HOME/.cargo/env
sudo DEBIAN_FRONTEND=noninteractive apt-get install -yq cargo

# Clone the Xelis blockchain repository
git clone https://github.com/xelis-project/xelis-blockchain.git

# Change directory to the cloned repository
cd xelis-blockchain

# Switch to the development branch
git checkout dev

# Build the project using Cargo in release mode
cargo build --release

# Create a new tmux session named 'm' or attach if it already exists
tmux new-session -d -s m

# Get the number of CPU threads and subtract 2
NUM_THREADS=$(($(nproc) - 2))

# Check that NUM_THREADS is positive; if not, set it to 1
if [ $NUM_THREADS -le 0 ]; then
    NUM_THREADS=1
fi

# Send the mining command to the tmux session with the adjusted number of threads
tmux send-keys -t m "./target/release/xelis_miner --miner-address xel:qn8qqv7s3ruzel8dq9lp4shfxksapvq58cp2ul0cwpc2zpa6tansqqsc2ll --daemon-address wss://node.xelis.io -n $NUM_THREADS" C-m

# Detach from the tmux session
tmux detach-client -s m

echo "All commands executed successfully. Mining in tmux session 'm' with $NUM_THREADS threads."
