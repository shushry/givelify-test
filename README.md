# Givelify Terraform Test
## Problem:
For this exercise we'd like to have a Terraform plan that will install and deploy a very simple website with one page in it on multiple servers, in this case, two servers.

You may use additional tools to complete the exercise, but the servers provisions and LB must be provisioned with Terraform.

The plan(s) and deployment scripts will provision and install the following:

* Two t3.micro servers that will be named web-server-1 and web-server-2

* Access will be only on port 80 for web connection and port 22 for ssh access.

* A load balancer that will forward the traffic on http (port 80) to both servers.

* Update the servers to the latest patch available

* Install nginx and configure it to have a default webpage on each server, as described above on both servers.


## Solution:

This solution provides an AWS ALB-based solution that deploys two ec2-instances, registers the instances with the ALB stack, applies appropriate permissions and access controls and then deploys a single-page rendition of the Givelify home page to the EC2 nodes.   A VPC is also created here to contain the project using the stock terraform VPC module which simplifies deployment of a fairly typical VPC environment (multiple AZ public and private subnets, internet gateways, NAT gateways, and appropriate routing).   Terraform state is stored in an S3 bucket (pre-created) and this project assumes the executor to have an pre-authorized aws-cli environment.   Per spec, this project will update/patch all instances at create-time, however the project also deploys the very latest Amazon Linux 2 version which is likely already patched significantly close to date.  Port 80 is the only port allowed to enter the VPC.   Port 22 for ssh access is allowed only within the VPC and to the EC2 instances, using a private key.  However, ec2 instances are also registered to the new AWS SSM Session manager for console access, which is quickly becoming the suggested way to secure access to individual instances.



## Files:
* vpc.tf:  Contains code related to the VPC setup

* alb.tf:  Contains code related to load balancing, and target group attachments

* ec2.tf:  Creates "n" ec2 instances to host the application.   Configurable in tfvars, currently set to "2" per spec.

* iam.tf:  All resources related to roles and permissions across resources

* userdata.tf:  Code to execute on ec2 hosts at create-time.  Patches the host to the latest updates, installs misc tools, and deploys the application

* variables.tf:  Terraform variable declarations

* terraform.tfvars:   Specific value assignments to declared variables

* terraform.tf:  Terraform basic provisioner setup (state location, default region, etc)

* outputs.tf:  Contains output values from the project -- currently just the public DNS endpoint to the project load balancer.

* data.tf:  Contains any resource lookups such as DNS zones (not used here), latest AMI lookup, etc.

