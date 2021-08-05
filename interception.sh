#!/bin/sh
# Rebinds escape tools
sudo mkdir -p /etc/interception/dual-function-keys
sudo cp ./interception/builtin.yaml /etc/interception/dual-function-keys
sudo cp ./interception/udevmon.yaml /etc/interception
sudo ln -s /etc/interception/dual-function-keys/builtin.yaml /etc/interception/dual-function-keys/thinkpad-kb.yaml

