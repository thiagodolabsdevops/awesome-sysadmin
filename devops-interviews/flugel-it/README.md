# Infrastructure Developer tests

## Test 1 - AWS, S3, Python, Terraform and Github actions

- Create Terraform code to create a AWS S3 bucket with two files: test1.txt and test2.txt. The content of these files must be the timestamp when the code was executed.
- Using Terratest, create the test automation for the Terraform code, validating that both files and the bucket are created successfully. 
- Setup Github Actions to run a pipeline to validate this code.
- Publish your code in a public GitHub repository, and share a Pull Request with your code. Do not merge into master until the PR is approved.
- Include documentation describing the steps to run and test the automation.
- I want a cluster of 2 EC2 instances behind an ALB running Traefik, to proxy the connections to the files in the S3 bucket.
- The cluster must be deployed in a new VPC. This VPC must have only one public subnet. Do not use default VPC.
- Protect the files in the S3 bucket, so only the EC2 instances using IAM roles can access to them.
- Update the tests to validate the infrastructure. Test must check that files are reachable in the ALB.
- I want a K8s cluster running Nginx, to serve the files in the S3 bucket.
- Use a init container with a Python script to pull those files. They must be served in a volume in the K8s cluster, not from s3.
- The cluster must be deployed in a new VPC. This VPC must have only one public subnet. Do not use default VPC.
- Protect the files in the S3 bucket, so only the EC2 instances using IAM roles can access to them.
- Update the tests to validate the infrastructure. Test must check that files are reachable in the ALB.

## Test 2 - AWS, Tags, Python, Terraform and GitHub actions

- Create Terraform code to create a S3 bucket and an EC2 instance. Both resources must be tagged with Name=<Candidate_Name>, Owner=InfraTeam.
- Using Terratest, create the test automation for the Terraform code, validating that both resources are tagged properly.
- Setup Github Actions to run a pipeline to validate this code.
- Publish your code in a public GitHub repository, and share a Pull Request with your code. Do not merge into master until the PR is approved.
- Include documentation describing the steps to run and test the automation.
- I want a cluster of 2 EC2 instances behind an ALB running Nginx, serving a static file. This static file must be generated at boot, using a Python script. Put the AWS instance tags in the file.
- The cluster must be deployed in a new VPC. This VPC must have only one public subnet. Do not use default VPC
- Update the tests to validate the infrastructure. Test must check that files are reachable in the ALB.
- I want a K8s cluster running Nginx, to serve some static files.
- Use a init container with a Python script to generate the file, write the ec2 instance tags of the k8s cluster on the file served by Nginx.
- The cluster must be deployed in a new VPC. This VPC must have only one public subnet. Do not use default VPC.
- Protect the files in the S3 bucket, so only the EC2 instances using IAM roles can access to them.
- Update the tests to validate the infrastructure. Test must check that files are reachable in the ALB.

## Questions for the interview

- What's the difference between containers and a VM?
- Describe the high level workflow to deploy an application to a Kubernetes cluster. In a few words.
- What's the difference between AWS NAT gateway and AWS Internet gateway.
- Could you describe what's immutable infrastructure?.
- Describe the Network layout to deploy an application with 10 microservices and 1 DB.
- What's the Terraform state?
- Describe the K8s Architecture.
- What's an IAM Role?
- Difference between Ansible and Chef/Puppet/SaltStack.
- What is continuous integration and continuous deployment?
- Why are you looking a new job?

---

## Technical evaluation - Part 1

- As a developer, I want a tool to list unused AWS resources to save costs. The tool input is a list of tags and it returns the list of EC2 instances and S3 buckets that don't match any of the tags in the N. Virginia region. Write the tool using Python 3.
- Implement some automatic tests to verify that the tool works as expected.
- Use Terraform to create resources to validate the tool works as expected.
- Package the application as a Docker image, so the user doesn't have to install python and other packages locally.
- Publish your code in a public GitHub repository, and share a Pull Request with your code. Do not merge into master until the PR is approved.
- Include documentation describing the steps to run and test the automation.

## Technical evaluation - Part 2

- Create a new PR to deploy an EKS cluster in a new VPC (not the default one).
- Deploy a hello world application in the cluster, and write a Python test to validate the Hello World is up and running.
- Use Terraform to manage everything, including the deployment of the application on K8s.

---

## Step 1: Clone the repo

```git clone https://github.com/tmagalhaes1985/flugel-assignment.git```

## Step 2: Configure your AWS credentials

Note that you are going to create resources in AWS cloud, so you need access to create / access / modify.

Configure your AWS Access Key and Secret Access Key as local environment variables to make the execution of the project tasks easier. This can be added to your ```~/.bashrc```:

```bash
export AWS_ACCESS_KEY_ID=<your AWS access key>
export AWS_SECRET_ACCESS_KEY=<your AWS secret access key>
```

## Step 3: Create the infrastructure using Terraform

You need [Terraform](https://releases.hashicorp.com/terraform/) to create AWS resources.

Running Terraform is preety straightforward. First enter the directory for the resources that you want to create and then run:

```bash
terraform init
terraform plan
terraform apply
```

Wait for the environment creation completes, and then proceed to the next steps.

NOTE: Keep in mind that running resources in AWS involves cost.

## Step 4: Build the containter image to execute our Python scripts

```cd scripts/ec2-s3/ && docker image build -t assignment:1.0 .```

## Step 5: Run mocked tests on Docker (optional)

To test the code, I used boto3 and moto to mock AWS resources localy. Just run:

```docker run -it --rm assignment:1.0 py.test```

It mocks and tests four scenarios:

- Create and check 2 x EC2 with/without the defined tags
- Create and check 2 x S3 buckets with/without the defined tags

## Step 6: Run the Python application against AWS resources

When you run the container with defined parameters, this executes all directly in AWS and returns to you in your screen:

```docker run -it --rm --env "AWS_ACCESS_KEY_ID" --env "AWS_SECRET_ACCESS_KEY" assignment:1.0 python main.py <parameters>```

You can change parameters to:

- ```'[{"InUse":"Yes"}]'```
- ```'[{"InUse":"No"}]'```

Example:

```docker run -it --rm --env "AWS_ACCESS_KEY_ID" --env "AWS_SECRET_ACCESS_KEY" assignment:1.0 python main.py '[{"InUse":"Yes"}]'```

## Step 7: Deploy a "Hello World" application to the EKS Cluster

This Terraform-based EKS cluster deployment will create the following:

- AWS managed K8s cluster
- AutoScaling Group
- Resources:
  - VPC
  - Subnets
  - Internet Gateway
  - Security Groups for Master and Worker nodes
  - IAM Roles for Master and Worker nodes

### AWS Stuff that you gonna need

Run the following script as sudo to download and configure:

```bash
#!/bin/bash -e

# aws-cli
pip3 install awscli --upgrade --user

# aws-iam-authenticator
curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/aws-iam-authenticator
curl -o aws-iam-authenticator.sha256 https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/aws-iam-authenticator.sha256

[[ `openssl sha1 -sha256 aws-iam-authenticator` == aws-iam-authenticator.sha256 ]];  chmod +x ./aws-iam-authenticator && mv ./aws-iam-authenticator /usr/bin/aws-iam-authenticator || echo "Checksum differs"

aws eks update-kubeconfig --name eks-cluster
```

Note that ```eks-cluster``` is our AWS-managed Kubernetes cluster name. This can be changed modifying the cluster-name variable in ```vars.tf``` file.
