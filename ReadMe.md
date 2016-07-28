# Simple setup of Cloud Foundry on Google Cloud Platform

![](timelapse-setup.gif)

These scripts were created for a springone conf demo and are designed to provide an easy bootstrap for exploring Cloud Foundry on Google Cloud Platform. The work here attempts to follow [the instructions](https://github.com/cloudfoundry-incubator/bosh-google-cpi-release/blob/master/docs/bosh/README.md) on the Cloud Foundry Incubator, [Bosh Google CPI](https://github.com/cloudfoundry-incubator/bosh-google-cpi-release) site. Special callout to [@nickspat](https://github.com/nickspat/setupcfongcp) for his help crafting all this. 

__NOTE:__ these scripts are not intended for a production deployment.
 

## Prerequisite

* Admin level access on a Google Cloud Project
	- It's recommended that you use a separate project just for this work
* Enable Compute Engine before running script
	- Simply access the compute engine section of the UI console
* Increase CPU Quotas 
	- On the quota page [request an increase](https://console.cloud.google.com/compute/quotas) in the cpu to 100 for the region listed in the constants file (us-west1-b) 
	

Note: The first run on a new project will probably fail as new project keys need to be stored. I simply ran the ``all-teardown.sh`` and tried the setup again


## One Step Setup

This script is designed to run from the [Google Cloud Shell](https://cloud.google.com/shell/docs/). Once downloaded the constants file and manifests can be modified to meed your needs. 

Manifest: You may choose to modify the manifest which is currently in the ``cf-setup.sh`` script. You may need to modify the stemcell version or sha to match [published versions](https://github.com/cloudfoundry-incubator/bosh-google-cpi-release). Alternatively you can update initial server counts to fit within the default project quota


### Setup

From Cloud Shell, download the code, change to the directory and execute the setup script

```
$ git clone https://github.com/cgrant/setupcfongcp.git
$ cd setupcfongcp
$ ./all-setup.sh
```


There are 2 spots where you'll need to interact. First is during `bosh target` which will ask you to login

1) login using admin / admin (or the credentials listed in constants.sh)

2) type yes when asked if you want to install

The entire setup process will take about an hour



### Teardown

Again this should be run from the cloud shell. I would suggest that you open a new shell, or just ensure you're in the shell in the root dir. 

```
$ cd setupcfongcp
$ ./all-teardown.sh
```

## Additional Info

### Step by step setup
You may chose to run the steps individually for debugging or just education. We've tried to keep the ``all-setup.sh`` and ``all-teardown.sh`` scripts simple. You should be able to used the commands listed there.

Do note when executing step by step that you need to be aware of where you're executing the commands. There are two systems at play here. Cloud shell is used to initialize the cloud infrastructure and bastion server. Once this is setup the majority of the Cloud Foundry setup commands are executed using ``bosh`` from within the bastion server. Suppose I should clean that up someday. 

Enjoy!!

 



