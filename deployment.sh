#!/bin/bash

podman stop solargeom
PROJECT_DIR=$(pwd)
SERVICE_DIR=/home/ubuntu/.config/systemd/user
mkdir -p ${SERVICE_DIR}
cd  ${SERVICE_DIR}
podman generate systemd --files --name solargeom
cd ${PROJECT_DIR}
loginctl enable-linger
systemctl --user enable --now container-solargeom.service 
