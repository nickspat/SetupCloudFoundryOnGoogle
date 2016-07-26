# Create and Setup Cloudfoundry on Google compute engine

## Pre-requisite
 * Admin/Project wide account on Google Cloud Project
 * Quota limits enhanced 

From [Google Cloud Shell](https://cloud.google.com/shell/docs/)

## Everything in one shot  

### Setup

```
$ git clone https://github.com/cgrant/setupcfongcp.git
$ cd setupcfongcp
$ ./all-setup.sh
```


There are 2 spots where you'll need to interact. First is during `bosh target` which will ask you to login

1) login using admin / admin (or the credentials listed in constants.sh)
2) type yes when asked if you want to install



### Cleanup
