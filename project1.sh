#!/bin/bash
# A basic script to update Kali Linux packages

echo "Starting system update..."
sudo apt update && sudo apt upgrade -y
echo "Cleaning up unnecessary packages..."
sudo apt autoremove -y
echo "Update complete!"

