# Create and Setup Cloudfoundry on Google compute engine

## Pre-requisite
 * Admin/Project wide account on Google Cloud Project

## Setup CloudFoundry  
Open google cloud shell (if you are using gcloud command line then make sure you have login and set the project)
`wget https://github.com/nickspat/setupcfongcp/raw/master/all-setup.sh && chmod 744 ./all-setup.sh && ./all-setup.sh`

## Delete CloudFoundry
Open google cloud shell (if you are using gcloud command line then make sure you have login and set the project)
`wget https://github.com/nickspat/setupcfongcp/raw/master/all-teardown.sh && chmod 744 ./all-teardown.sh && ./all-teardown.sh`