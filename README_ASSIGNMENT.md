# Project Documentation

## Overview

This document provides instructions for building and running the Docker container, triggering the CI/CD pipeline, and deploying the application using Terraform. It includes all relevant commands, configurations, and explanations to ensure a smooth setup and deployment process.

## Prerequisites and Assumptions
* Docker installed
* Terraform installed (to deploy to AWS from the local machine)
* AWS CLI configured with appropriate credentials (region set to `us-west-2`, or your preferred region)
* Following Secrets to be set in GitHub [actions](https://github.com/Amod1996/ipfs-metadata/settings/secrets/actions/new):
```
AWS_ACCESS_KEY_ID: <your-aws-acess-key>
AWS_SECRET_ACCESS_KEY: <your-aws-secret-key>
DOCKER_PASSWORD: blockpartysre
DOCKER_USERNAME: amodkc
POSTGRES_USER: testuser
POSTGRES_PASSWORD: testpassword
```
You can also change the docker hub username and password to your own account(make sure the repository is public)
* AWS s3 bucket to store terraform state file, currently in backend.tf, it is named to `staging-terraform-state-bucket--usw2-az1--x-s3`
* AWS DynamoDb table named  `terraform-locks`  to put a lock on state file

## How to Build and Run the Docker Container

### Build the Docker Image

To build the Docker image, use the following command:

```sh
docker-compose build
```
### Run the Docker Container
To run the Docker container, use the following command:
```sh
docker-compose up
```
### How to Trigger the CI/CD Pipeline
The CI/CD pipeline is configured using GitHub Actions. It is set to trigger on:

* Pushes to the main branch
* Pull requests to any branch
* Manual trigger
### Manual Trigger
To manually trigger the workflow:
* Navigate to the "Actions" tab in  GitHub repository.
* Select the "Build and Deploy" workflow.
* Click on the "Run workflow" button and select the branch to run the workflow.(The workflow completes and sleeps for 2 minutes to let task provisioned successfully)

### How to Deploy the Application Using Terraform (from local)
### Terraform Setup
Cd to `/infrastructure/aws/environment/staging` directory
Initialize Terraform:
```sh
terraform init
```
Check the terraform config using:
```sh 
terraform plan
```
Apply the Terraform configuration:

```sh
terraform apply -auto-approve
```


### How to check if application is running correctly on AWS
* Navigate to load balancer in EC2 and click on the load balancer and look for the url like `http://ipfs-metadata-alb-1872149953.us-west-2.elb.amazonaws.com`
* Go to the browser and access the url you got in previous step and you should be able to see results

### To access AWS RDS locally
* Navigate to AWS RDS and check for **blockparty-sre-db**, add your IP address in the security group associated with the database instance like `xxx.xxx.xxx.xxx/32` for the TCP request with port `5234`
* Next copy the `endpoint` and access db using  `psql -h <endpoint> -U testuser -d testdb`
* Once you are in the db instance, run `SELCT *FROM nft_metadata` after you have accessed the http:<metadataurl>/metadata

### Remove the Infrastructure after testing

Cd to `/infrastructure/aws/environment/staging` directory
Initialize Terraform:
```sh
terraform init
```
Apply the Terraform configuration:

```sh
terraform destroy -auto-approve
```
