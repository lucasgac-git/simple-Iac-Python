# simple-Iac-Python
This is a test deployment using simple python software and IaC

# Architecture

Cloud Provider: AWS
Infrastructure: Privisioned through Terraform and custom modules
Host Configuration: Ansible* (some steps are done in the host OS) 
Application language: Python and HTML
Database: MySQL


# Disclaimer

The application and several other configuration aspects of automation don't follow security best practices, as this is purely a test deployment to integrate and understand how to use these softwares together. Future versions of this project will be in seperate branches or possibly other reposity, as to seperate different levels of complexity, security, and automation.

## Project Walkthrough

1) Terraform

In this section, I'll explain what is going to be built with the Terraform code provided in the root main.tf file (and other too), and what do the custom modules do;

1.1. terraform-infra files:
    
    a - backends.tf: I'm using AWS S3 as a backend to remotly store the terraform.tfsate file in a subdirectory called state. The bucket is located in the region of your choosing;

    b - providers.tf: Regular provider file to use AWS. The region configuration is made to be a variable to be configured elsewhere;

    c - variables.tf: Configuring the default value for the region and the and the IP (or network) that is going to be able to access the services;

    d - locals.tf: Configuring the local values for the VPC CIDR, the public CIDR (Security group access), the region (static), and all the security groups and their specifications. 
    The security group definition here is for a dynamic block in the networking module (main.tf), in the Security Group section.; 

    e - output.tf: Print in the shell the public IP of the public instance.

    f - main.tf: Configures the main resources of the deployment


1.2. networking module:

    This module creates the network backend necessary for the deployment. The following are the resources defined in the code:

    a - a VPC;

    b - 2 subnets (1 private, 1 public) in a single AZ;

    c - 1 internet gateway;
        
    d - 1 elastic IP and 1 nat gateway (to allow private instances to download packages);

    e - 2 route tables. 1 public and 1 private, and it's associations;

    f - A security group definition with a dynamic ingress block, with rules defined in the locals.tf file in the root of the directory.


1.3. EC2 module

This module defines what configuration the EC2 instances will get:

    a - A data block for specifying an AMI: This block defines which AMI all the instances using this module will get. 
    The AMI id and other data changes from different regions and AZs, so it's necessary identify which one is required for your region of choice;

    b - 1 Private key generation to the instance;

    c - 1 Instance definition (in the Public subnet);

1.4. EC2-private module

This module is used for the Database. Configuration follows the same as above, but the instance is allocated to the Private subnet (does not have a public available IP), and it also has a "user data" block to install ansible repositories for local execution;

Disclaimer: this instance can only be accessed through the EC2 public instance

