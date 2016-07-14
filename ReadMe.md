# Create and Setup Cloudfoundry on Google compute engine

## Pre-requisite
 * Admin/Project wide account on Google Cloud Project


## Setup CloudFoundry  
On google cloud shell sdk type 
`gsutil cp gs://hd-labs-cfongcp/automation/oneclick-cf-on-gcp.sh . && chmod 744 ./oneclick-cf-on-gcp.sh && ./oneclick-cf-on-gcp.sh`

## Delete CloudFoundry
On google cloud shell sdk type 
`gsutil cp gs://hd-labs-cfongcp/automation/oneclick-delete-all.sh . && chmod 744 ./oneclick-delete-all.sh && ./oneclick-delete-all.sh`