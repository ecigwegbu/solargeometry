#!/bin/bash

### THIS SCRIPT IS NOT TO BE EXECUTED 'AS IS'. IT MERELY LISTS USEFUL COMMANDS ###
# Use the commands as a handy reference

# Make sure Helm is already installed and configured in your machine - see separate guide for that
helm version
helm list

# This script shows how to add a GitHub repo as a Helm repo, using solargeometry app as example
# First, make sure your Git/Github repo contains a subdirectory named <your-app> that contains
# a valid Helm chart structure, including at least Chart.yaml and templates directory

# Example structure:
# [ubuntu@rhel9-win solargeometry]$ pwd
# /home/ubuntu/git/solargeometry
# [ubuntu@rhel9-win solargeometry]$ tree -L 3 helm-chart
# helm-chart
# ├── helm-git.sh
# ├── index.yaml
# ├── solargeometry
# │   ├── charts
# │   ├── Chart.yaml
# │   ├── templates
# │   │   ├── deployment.yaml
# │   │   ├── secret.yaml
# │   │   └── service.yaml
# │   └── values.yaml
# └── solargeometry-0.1.0.tgz

# Now add the helm-git plugin to Helm:
helm plugin install https://github.com/aslafy-z/helm-git.git

# Now within the 'helm-chart' folder (name it as required) that contains the 
# solargeometry helm chart run this command, then commit and push it to GitHub:

helm repo index . --url https://github.com/ecigwegbu/solargeometry/raw/main/helm-chart  # creates index.yaml

# Now the helm repo exists in GitHub. You can add the GitHub helm repo to your local machine:
helm repo add solargeometry https://github.com/ecigwegbu/solargeometry/raw/main/helm-chart

# Now you can install the solargeometry app into your Kubernetes Cluster from your local helm repo:
helm install solargeometry solargeometry/solargeometry -f ~/.secrets/SOLARGEOMETRY_SECRET_FILE 

# Confirm that the app is deployed:
kubectl get deploy solargeometry -o wide
kubectl get pod -o wide
kubectl get pod -o wide --watch  # may take a few minutes to be 'ready'

# Note that you can also install solargeometry directly from Github, 
# if there is a valid helm .tgz file there, even without a helm repo

helm install solargeometry https://github.com/ecigwegbu/solargeometry/raw/main/helm-chart/solargeometry-0.1.0.tgz \
  -f ~/.secrets/SOLARGEOMETRY_SECRET_FILE

# BUT: If you try to install solargeometry from the GitHub Helm Repo directly (without using the .tgz file):
# helm install solargeometry https://github.com/ecigwegbu/solargeometry/raw/main/helm-chart
# Error: INSTALLATION FAILED: file '/home/ubuntu/.cache/helm/repository/helm-chart' does not 
# appear to be a gzipped archive; got 'text/html; charset=utf-8'

