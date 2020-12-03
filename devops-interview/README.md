# Infrastructure Developer tests

The evaluation for new team members has two main parts:

- A first and short interview in 30 minutes. We send beforehand the first part of the tests listed below, and expect a 15 mins demo in this meeting.
This is a pre qualification stage, we evaluate English, review skills and we try to see if the candidate know what he coded with a demo and a code walkthru.
- A second and longer interview in 1 hour. After the first call, we send one of the follow up tasks. In the call we evaluate skills with Q&A, we talk about experience, etc. We do a demo and a code walkthru again in the call.

Candidate must send a PR before the calls to do a code review. We can ask modifications if it's needed.

## Test 1 - AWS, S3, Python, Terraform and Github actions

### For the first meeting

- Create Terraform code to create a AWS S3 bucket with two files: test1.txt and test2.txt. The content of these files must be the timestamp when the code was executed.
- Using Terratest, create the test automation for the Terraform code, validating that both files and the bucket are created successfully. 
- Setup Github Actions to run a pipeline to validate this code.
- Publish your code in a public GitHub repository, and share a Pull Request with your code. Do not merge into master until the PR is approved.
- Include documentation describing the steps to run and test the automation.

### Options for the second meeting

#### Option #1

- Merge any pending PR.
- Create a new PR with code and updated documentation for the new requirement.
- I want a cluster of 2 EC2 instances behind an ALB running Traefik, to proxy the connections to the files in the S3 bucket.
- The cluster must be deployed in a new VPC. This VPC must have only one public subnet. Do not use default VPC.
- Protect the files in the S3 bucket, so only the EC2 instances using IAM roles can access to them.
- Update the tests to validate the infrastructure. Test must check that files are reachable in the ALB.

#### Option #2

- Merge any pending PR.
- Create a new PR with code and updated documentation for the new requirement.
- I want a K8s cluster running Nginx, to serve the files in the S3 bucket.
- Use a init container with a Python script to pull those files. They must be served in a volume in the K8s cluster, not from s3.
- The cluster must be deployed in a new VPC. This VPC must have only one public subnet. Do not use default VPC.
- Protect the files in the S3 bucket, so only the EC2 instances using IAM roles can access to them.
- Update the tests to validate the infrastructure. Test must check that files are reachable in the ALB.

## Test 2 - AWS, Tags, Python, Terraform and GitHub actions

### For the first meeting

- Create Terraform code to create a S3 bucket and an EC2 instance. Both resources must be tagged with Name=<Candidate_Name>, Owner=InfraTeam.
- Using Terratest, create the test automation for the Terraform code, validating that both resources are tagged properly.
- Setup Github Actions to run a pipeline to validate this code.
- Publish your code in a public GitHub repository, and share a Pull Request with your code. Do not merge into master until the PR is approved.
- Include documentation describing the steps to run and test the automation.

### Options for the second meeting

#### Option #1

- Merge any pending PR.
- Create a new PR with code and updated documentation for the new requirement.
- I want a cluster of 2 EC2 instances behind an ALB running Nginx, serving a static file. This static file must be generated at boot, using a Python script. Put the AWS instance tags in the file.
- The cluster must be deployed in a new VPC. This VPC must have only one public subnet. Do not use default VPC
- Update the tests to validate the infrastructure. Test must check that files are reachable in the ALB.

#### Option #2

- Merge any pending PR.
- Create a new PR with code and updated documentation for the new requirement.
- I want a K8s cluster running Nginx, to serve some static files.
- Use a init container with a Python script to generate the file, write the ec2 instance tags of the k8s cluster on the file served by Nginx.
- The cluster must be deployed in a new VPC. This VPC must have only one public subnet. Do not use default VPC.
- Protect the files in the S3 bucket, so only the EC2 instances using IAM roles can access to them.
- Update the tests to validate the infrastructure. Test must check that files are reachable in the ALB.

#### More Follow ups ideas

- Follow ups are about adding a new feature to the code, but the test depends on the conversation with the candidate. Some ideas.

## Questions for the interview

- What's the difference between containers and a VM?
- Describe the high level workflow to deploy an application to a Kubernetes cluster. In a few words.
- What's the difference between AWS NAT gateway and AWS Internet gateway.
- Could you describe what's immutable infrastructure?.
- Descibe the Network layout to deploy an application with 10 microservices and 1 DB.
- What's the Terraform state?
- Describe the K8s Architecture.
- What's an IAM Role?
- Difference between Ansible and Chef/Puppet/SaltStack.
- What is continuous integration and continuous deployment?
- Why are you looking a new job?
