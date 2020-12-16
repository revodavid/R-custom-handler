# To enable ssh & remote debugging on app service change the base image to the one below
FROM mcr.microsoft.com/azure-functions/dotnet:3.0-appservice 
ENV AzureWebJobsScriptRoot=/home/site/wwwroot \
    AzureFunctionsJobHost__Logging__Console__IsEnabled=true

RUN apt-get update -qq && apt-get install -y \
  libcurl4-openssl-dev \
  git-core \
  libssl-dev \
  libsodium-dev

RUN apt-get install -y r-base

RUN R -e "install.packages(c('caret','plumber'), repos='http://cloud.r-project.org')"

COPY . /home/site/wwwroot