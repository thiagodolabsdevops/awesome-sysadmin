# DevOps Assignment

**Note**: Try to implement as much functionalities as possible and provide proper description wherever applicable

1. Cloud formation script to create below AWS components

    - VPC with two public and private subnets
    - Route tables for each subnet
    - Security Group to allow port 80 and 443
    - ELB and ALB
    - Private route53 hosted zone and CNAME entry for both ALB and ELB
    - IAM Policy for assignment-3

2. Ansible playbook to do following task

    - Pick a Linux AMI
    - Install webserver (Apache/Nginx)
    - Download code from git
    - Configure webserver with security best practices (List them)
    - Create a self-signed certificate
    - Secure a demo site using self-signed certificate

3. Execute Ansible playbook

    - Run Ansible playbook in a packer job and create AMI
    - Automatically create ASG using AMI created in above step and attach it to ELB.
    - Showcase capability of ALB, by created two different domain route policy.
    - Instance launched behind ELB/ALB should have role attached having access to s3 specific bucket, pull images from S3.

4. Create a script using any preferred programming language (python, Node.js, java etc.) to perform following activities

    - List AWS services being used region wise
    - List each service in detail, like EC2, RDS etc.
