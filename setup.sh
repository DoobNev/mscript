#!/bin/bash

# Exit script if any command fails
set -e

# Update the system packages
sudo apt update

# Install Git and tmux
sudo apt install git tmux -y

# Install Rust via rustup with no user interaction
curl --proto '=https' --tlsv1.3 https://sh.rustup.rs -sSf | sh -s -- -y

# Ensure the Cargo environment is set up
source $HOME/.cargo/env
sudo apt install cargo -y

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

# Send the mining command to the tmux session
tmux send-keys -t m './target/release/xelis_miner --miner-address xel:qn8qqv7s3ruzel8dq9lp4shfxksapvq58cp2ul0cwpc2zpa6tansqqsc2ll --daemon-address wss://node.xelis.io' C-m

# Detach from the tmux session
tmux detach-client -s m

# Check if a reboot is needed after updates and log it
if [ -f /var/run/reboot-required ]; then
  echo "$(date): Reboot required to load the new kernel." >> /path/to/reboot.log
fi

echo "All commands executed successfully. Mining in tmux session 'm'."
