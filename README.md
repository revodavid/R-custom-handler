# Azure Functions for R with Custom Handlers

This repository demonstrates using Azure Functions and the Custom Handlers feature to create serverless services in the R language.

## Pre-Requisites

1. You will need an Azure Subscription to run this example. If you don't have an Azure Subscription, you [can get one for free with $200 in Azure credits here](https://azure.microsoft.com/free/?WT.mc_id=javascript-10496-davidsmi).

2. You will need a local machine on which to run Azure CLI commands, and run the Shiny application. I have tested this with WSL2 and Ubuntu 20, but it should also work with native Windows, Linux, Mac, or indeed any platform that runs R and the Azure CLI.

3. Make sure the Azure CLI, Azure Functions Core Tools, and Docker are installed on your local machine [as described here](https://docs.microsoft.com/en-us/azure/azure-functions/functions-create-function-linux-custom-image?pivots=programming-language-other&tabs=bash%2Cportal&WT.mc_id=javascript-10496-davidsmi#configure-your-local-environment).

4. Make sure R is installed on your local machine, along with the "shiny" package. I've tested using R 3.6.3 and R 4.0.2, but any recent version of R should work. You may also want to install the "caret" and "plumber" packages if you want to test the Function locally.

5. You will also need a Docker ID for use with [Docker Hub](https://hub.docker.com/). (You _could_ use another container registry like Azure Container Registry, but I don't cover the details of that here.)

1. Clone this repository to your local machine, with `git clone <url-of-this-repo>`.

## Deploy the Function

This process largely follows that of ["Create a function on Linux using a custom container"](https://docs.microsoft.com/en-us/azure/azure-functions/functions-create-function-linux-custom-image?pivots=programming-language-other&tabs=bash%2Cportal&WT.mc_id=javascript-10496-davidsmi) on Microsoft Docs, but using the files in this repository.

I will show Azure CLI commands using `bash`, but you can adapt this to any shell.



Log into Azure:

`az login`

Choose an Azure region to host your function. Choose a region that supports [Azure Functions Premium plan Linux](https://azure.microsoft.com/global-infrastructure/services/?products=functions&WT.mc_id=javascript-10496-davidsmi). Provide the `Name` (not the `Display Name`) as shown by `az account list-locations -o table`. Also choose a name for a resource group to contain your Function assets (you can delete this resource group after you're done to eliminate any ongoing charges).

```bash
FR_LOC="westus2"
FR_RG="R-fun-rg"
```
Also choose a name for your function and a storage account to host assets. Both these names need to be globally unique, so you will need to change them from the values shown below. Use only lowercase letters and numbers, up to 24 characters max.

```bash
FR_FUNCTION="rfunc0001" 
FR_STORAGE="rstrg0001"
```

Finally, provide your Docker ID. (You can't use mine.)

```bash
DOCKER_ID="revodavid"
```



```



## Test the Shiny application

