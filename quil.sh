#!/bin/bash

# Update and install necessary packages
sudo apt update -y
sudo apt install git -y
sudo apt install tar -y
sudo apt install tmux -y

# Install Rust with default options (non-interactive)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

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

# Start tmux session, wait for 3 seconds, and then run script
tmux new-session -d -s quil
sleep 3
tmux send-keys -t quil './poor_mans_cd.sh' Enter
