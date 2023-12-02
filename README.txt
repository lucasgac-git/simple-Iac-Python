Objectives:

Simple 2-tier web app with database connection and query
Terraform -Infrastructure as code (networking, security groups, EC2 only)
S3 - Terraform state backend
DB ec2 instance configured through Ansible
Github to push the project

VPC
    10.20.0.0/16


Python Web applicattion in a public subnet that connects to a mysql database in a private subnet
    Webapp-sg -> 3306 -> db-sg 

