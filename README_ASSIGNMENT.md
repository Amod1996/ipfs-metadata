# Project Documentation

## Overview

This document provides instructions for building and running the Docker container, triggering the CI/CD pipeline, and deploying the application using Terraform. It includes all relevant commands, configurations, and explanations to ensure a smooth setup and deployment process.

## Prerequisites and Assumptions
* You should have Docker installed
* You should have Terraform installed (to deploy to AWS from the local machine)
* AWS CLI configured with appropriate credentials both at local and Github Action level(last point of Prerequisites and Assumption)
* Currently the `aws region` is set to `us-west-2` which can be changed [here](https://github.com/Amod1996/ipfs-metadata/blob/18c9dd383b5ffb4b93eb12c29c2c453aa6e16e8c/infrastructure/aws/environment/staging/vpc.tf#L2)) for deploying to AWS
* AWS S3 bucket created to store terraform state file, currently in [backend.tf](https://github.com/Amod1996/ipfs-metadata/blob/18c9dd383b5ffb4b93eb12c29c2c453aa6e16e8c/infrastructure/aws/environment/staging/backend.tf#L3), it is named to `staging-terraform-state-bucket--usw2-az1--x-s3`
* AWS DynamoDb table named  `terraform-locks` created to put a lock on state file
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
* Navigate to the "Actions" tab in  GitHub repository
* Select the "Build and Deploy" workflow
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
It will prompt you to put value for `var.postgres_user` and `var.postgres_password`
Enter the value which you stored in github secrets [above](https://github.com/Amod1996/ipfs-metadata/blob/main/README_ASSIGNMENT.md#prerequisites-and-assumptions)

### How to check if application is running correctly on AWS
* Navigate to load balancer in EC2 and click on the load balancer and look for the DNS name like `http://ipfs-metadata-alb-1872149953.us-west-2.elb.amazonaws.com`
* Go to the browser and access the `<url>/metadata` with url as DNS name you got in previous step and you should be able to see results

### To access AWS RDS locally
* Navigate to AWS RDS and check for **blockparty-sre-db**, add your IP address in the security group associated with the database instance like `xxx.xxx.xxx.xxx/32` for the TCP request with port `5432`
* Next copy the `endpoint` and access db using  `psql -h <endpoint> -U testuser -d testdb`
* Once you are in the db instance, run `SELCT *FROM nft_metadata` after you have accessed the http:<metadataurl>/metadata

### Remove the Infrastructure after testing(from local)

Cd to `/infrastructure/aws/environment/staging` directory
Initialize Terraform:
```sh
terraform init
```
Apply the Terraform configuration:

```sh
terraform destroy -auto-approve
```
It will prompt you to put value for `var.postgres_user` and `var.postgres_password`
Enter the value which you stored in github secrets [above](https://github.com/Amod1996/ipfs-metadata/blob/main/README_ASSIGNMENT.md#prerequisites-and-assumptions)
### Remove the Infrastructure after testing(using GitHub Action pipeline)
* Edit your `main.yml` file which recides in `.github/workflows/main.yml` [here](https://github.com/Amod1996/ipfs-metadata/blob/18c9dd383b5ffb4b93eb12c29c2c453aa6e16e8c/.github/workflows/main.yml#L74) and change it to `terraform destroy -auto-approve`
* Commit your changes and push it your your branch, this will automatically trigger the Github Action workflow and you should be able to delete the infrastructure created.

Please reach out to amodkc.iitm@gmail.com if you have any questions.
