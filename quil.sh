#!/bin/bash

# Update and install necessary packages
sudo apt update -y
sudo apt install git -y
sudo apt install tar -y
sudo apt install tmux -y

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Install Go
wget https://golang.org/dl/go1.20.11.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.20.11.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
echo 'export GOPATH=~/go' >> ~/.bashrc

# Reload environment variables
source ~/.bashrc

# Clone and navigate to the repository
git clone https://github.com/QuilibriumNetwork/ceremonyclient
cd ceremonyclient/node

# Start tmux session and run script
tmux new-session -s quil ./poor_mans_cd.sh
