#!/bin/bash

export GO111MODULE="on"
export GOPATH=/var/gopath
ACG_CONFIG="$(pwd)/cdappconfig.json"  go test -v -race -coverprofile=coverage.txt -covermode=atomic ./...

if [ $? != 0 ]; then
    exit 1
fi

# --------------------------------------------
# Options that must be configured by app owner
# --------------------------------------------
APP_NAME="ingress"  # name of app-sre "application" folder this component lives in
COMPONENT_NAME="ingress"  # name of app-sre "resourceTemplate" in deploy.yaml for this component
IMAGE="quay.io/cloudservices/insights-ingress"  

IQE_PLUGINS="ingress,advisor,host_inventory"
IQE_MARKER_EXPRESSION="smoke"
IQE_FILTER_EXPRESSION=""


# Install bonfire repo/initialize
CICD_URL=https://raw.githubusercontent.com/RedHatInsights/bonfire/master/cicd
curl -s $CICD_URL/bootstrap.sh -o bootstrap.sh
source bootstrap.sh  # checks out bonfire and changes to "cicd" dir...

source build.sh
source deploy_ephemeral_env.sh
source smoke_test.sh

