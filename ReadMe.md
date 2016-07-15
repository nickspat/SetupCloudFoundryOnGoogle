# Create and Setup Cloudfoundry on Google compute engine

## Pre-requisite
 * Admin/Project wide account on Google Cloud Project


## Setup CloudFoundry  
Open google cloud shell (if you are using gcloud command line then make sure you have login and set the project)
`wget https://gist.github.com/nickspat/77430d2958e6b5a012674edb64dd8ed6/raw/bc2d0ea0d037f0d1d73dd932d4541f1b4f6eae29/oneclick-cf-on-gcp.sh && chmod 744 ./oneclick-cf-on-gcp.sh && ./oneclick-cf-on-gcp.sh`

## Delete CloudFoundry
Open google cloud shell (if you are using gcloud command line then make sure you have login and set the project)
`wget https://gist.github.com/nickspat/77430d2958e6b5a012674edb64dd8ed6/raw/bc2d0ea0d037f0d1d73dd932d4541f1b4f6eae29/oneclick-delete-all.sh && chmod 744 ./oneclick-delete-all.sh && ./oneclick-delete-all.sh`