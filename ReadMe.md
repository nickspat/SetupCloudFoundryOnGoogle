# Create and Setup Cloudfoundry on Google compute engine

## Pre-requisite
 * Admin/Project wide account on Google Cloud Project

From (Google Cloud Shell)[https://cloud.google.com/shell/docs/]

## Everything in one shot  

### Setup

```
$ git clone https://github.com/cgrant/setupcfongcp.git
$ cd setupcfongcp
$ ./cloud-shell.sh
```

old
```
$ curl -o all-setup.sh https://raw.githubusercontent.com/nickspat/setupcfongcp/master/all-setup.sh && . ./all-setup.sh
```

There are 2 spots where you'll need to interact. First is during `bosh target` which will ask you to login

1) login using admin / admin (or the credentials listed in constants.sh)
2) type yes when asked if you want to install



### Cleanup

```
$ curl -o all-teardown.sh https://raw.githubusercontent.com/nickspat/setupcfongcp/master/all-teardown.sh && . ./all-teardown.sh
```

## SETUP Individual Components One by One

### Setup Infrastructure
```
$ curl -o infra-setup.sh https://raw.githubusercontent.com/nickspat/setupcfongcp/master/infra-setup.sh && . ./infra-setup.sh
```
### Setup Director
```
source ./constants.sh && gcloud compute ssh bosh-bastion --zone ${google_zone} --command "wget https://raw.githubusercontent.com/nickspat/setupcfongcp/master/director-setup.sh && chmod 744 ./director-setup.sh && ./director-setup.sh"

```



===


## TEARDOWN Individual Components One by One

### Teardown Infrastructure
```
$ curl -o infra-teardown.sh https://raw.githubusercontent.com/nickspat/setupcfongcp/master/infra-teardown.sh && . ./infra-teardown.sh



```
### Teardown Director
```


$ source ./constants.sh && gcloud compute ssh bosh-bastion --zone ${google_zone} --command "wget https://raw.githubusercontent.com/nickspat/setupcfongcp/master/director-teardown.sh && chmod 744 ./director-teardown.sh && ./director-teardown.sh"
```
