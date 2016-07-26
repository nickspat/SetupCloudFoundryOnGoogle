#!/usr/bin/env bash

set -e

source ./constants.sh


echo "-----------Setting up BOSH director ----------------"
./director-setup.sh
