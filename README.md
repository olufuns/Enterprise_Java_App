# Enterprise_Java_App

Project by Olufunso Ojo

Introduction
This is the deployment of an enterprise Java application for Peniel palmarius concepts limited.

Project Overview

This project revolves around automating the continuous integration and delivery process using a Jenkins pipeline. It replaces manual steps with automated actions between the staging and production environments. The pipeline encompasses continuous integration up to the staging phase and continuous delivery to the production environment. Additionally, the project utilizes an Auto Scaling Group (ASG) to launch instances from the staging environment to the production setup.
The project also illustrates how Jenkins triggers Ansible playbooks to dynamically update IP addresses in the host inventory file whenever there are changes to instances triggered by the ASG. Furthermore, it demonstrates how these playbooks are activated to deploy a Docker image as a container within the Docker host environment. All these processes are initiated upon activating the Vault component.
The resources involved in this project for continuous integration and deployment/delivery include:
1.	Terraform (Infrastructure as Code)
o	VPC
o	Subnets (Private and Public)
o	Internet Gateway
o	NAT Gateway
o	Route Tables and associations
o	Key pair
o	Security Groups
2.	GitHub (Version Control and Code Repository)
o	Used for code storage, version control, and collaboration among developers.
3.	Jenkins Server (Continuous Integration/Continuous Delivery)
o	Clones source code from GitHub and generates artifacts using tools like Maven.
4.	Ansible Server (Infrastructure as Code)
o	Handles file storage, including Playbooks and IPs.
o	Acts as an interface between Ansible and Jenkins.
5.	Docker Host (Containerization)
o	Utilized to create Docker containers from Docker images.
o	Docker images are built through interactions between Jenkins and Ansible.
6.	New Relic (Performance Monitoring)
o	Provides performance and availability monitoring for the application.
7.	Slack (Communication and Collaboration)
o	Used for communication and collaboration among team members.
8.	Nexus (Artifact Repository)
o	Stores artifacts generated during the build process.
9.	Docker Hub (Container Repository)
o	Stores Docker images for deployment.
10.	Amazon Web Services (AWS)
o	Provides cloud infrastructure for hosting applications.
11.	Visual Studio Code (IDE)
o	A development environment for writing and managing code.

Architectural Diagram: The infrastructural diagram illustrates the connectivity and interactions among these tools and resources. It serves as a crucial blueprint for designing and building the necessary infrastructures, enabling effective teamwork towards the complete automation of the Pet Adoption Project.

Project Documentaion

Provider

provider "aws" {
  region  = "eu-west-2"
  profile = "default"
}

In Terraform the provider block contains the information, for establishing a connection with a cloud or service provider. The AWS provider block you've provided includes details such as the region and AWS profile that will be utilized in your Terraform configuration.

Here's an explanation of each attribute, within your AWS provider block;

region; This attribute determines the AWS region where your resources will be created or managed. In this example the region is set to "eu west 2," which corresponds to the EU (Ireland) region. You have the flexibility to modify this value according to your preferred AWS region.

Profile: The "profile" attribute specifies the named AWS profile to be used for authentication. AWS profiles are typically configured in the AWS CLI or via the AWS credentials file (~/.aws/credentials). The "default" profile is commonly used and relies on AWS access key and secret key credentials. You can specify a different profile if you have multiple AWS profiles configured on your system.

By providing these details in the provider block, Terraform knows how to authenticate and which AWS region to target when creating or managing resources.


locals {
  name = "peniel"
}

In Terraform we use the block to create named values or expressions that can be reused in our configuration. These values are calculated during the planning phase.We often use them to simplify expressions make our code more readable or avoid repetition.

In the project I have defined a value called "name" with the value "peniel". You can then refer to this value in sections of your Terraform configuration.




HashiCorp Vault

HashiCorp Vault is an open-source tool for managing and securing secrets, credentials, and other sensitive data used in modern cloud and application environments. It provides a centralized and secure way to store, access, and manage sensitive information such as passwords, API keys, certificates, and encryption keys. Vault is designed to help organizations enhance security and compliance by providing robust access controls and encryption for data at rest and in transit.

Key features and concepts of HashiCorp Vault include:

Secrets Management: Vault allows you to store and manage a wide range of secrets and sensitive data, providing an organized and secure repository for credentials and keys.

Dynamic Secrets: Vault can generate dynamic, short-lived credentials for databases, cloud services, and more. This approach improves security by reducing the risk of long-lived static credentials being compromised.

Encryption as a Service: Vault can act as an encryption service, providing encryption keys and handling encryption and decryption operations, which is crucial for data protection.

Access Control: Vault offers fine-grained access control policies that enable you to define who can access, read, or modify secrets. Policies can be tied to authentication methods such as tokens, LDAP, or identity providers.

Audit Logging: Vault maintains detailed audit logs of all access and modification to secrets, which is essential for compliance and security monitoring.

High Availability: Vault supports high availability configurations to ensure that the service remains accessible even in the event of failures or outages.

Integration with Identity Providers: You can integrate Vault with various identity providers, including LDAP, Active Directory, and cloud identity services.

API-Driven: Vault provides a REST API for programmatic access, enabling automation and integration with other tools and systems.

Authentication Methods: Vault supports a variety of authentication methods, such as token-based authentication, username/password, AWS IAM, and more.

Dynamic Secrets Renewal and Revocation: Vault can automatically renew dynamic secrets and also revoke them when they are no longer needed.

Data Encryption: Data stored in Vault is encrypted at rest and can be encrypted in transit using TLS.

Extensible: Vault's functionality can be extended through the use of plugins and external modules.

Vault is particularly valuable in cloud-native and containerized environments, where secure secret management and dynamic credentials are essential for microservices, containers, and serverless applications.

HashiCorp offers both an open-source version of Vault and an enterprise version with additional features and support. Vault is a versatile tool that can be used in a wide range of use cases, including DevOps, security, and infrastructure management, and it is widely adopted in the industry for securing secrets and sensitive data.





High availability

High availability (HA) is a critical requirement in cloud infrastructure to ensure that your applications and services remain accessible and operational even in the face of hardware failures, network issues, or other types of disruptions. To achieve high availability in a Virtual Private Cloud (VPC) on a cloud platform like AWS, you typically need to implement redundancy, load balancing, and failover strategies. Here are some key components and strategies for achieving high availability in a VPC:

Multi-Availability Zone (AZ) Deployment:

Deploy resources in multiple availability zones within the same region. AWS, for example, offers multiple AZs within each region, and each AZ is isolated from the others, which helps mitigate failures in one AZ.
Load Balancers:

Use load balancers to distribute incoming traffic across multiple instances. This ensures that even if one instance fails, the load balancer can route traffic to healthy instances.
AWS provides services like Application Load Balancers (ALB) and Network Load Balancers (NLB) that can help with this.
Auto Scaling:

Implement auto scaling to automatically adjust the number of instances based on demand. This allows you to scale out during traffic spikes and scale in during low traffic, improving cost efficiency and availability.
Database High Availability:

Use database replication and clustering to ensure database availability. Implementing master-slave replication or database clustering can help maintain data consistency and availability in case of database server failures.
AWS offers managed database services like Amazon RDS with multi-AZ deployments for database high availability.
Data Replication:

Replicate data across multiple regions to guard against region-wide failures. AWS provides services like Amazon S3 cross-region replication for data durability and availability.
Content Distribution:

Use content delivery networks (CDNs) to distribute content and improve availability by caching content at edge locations closer to end-users.
Backup and Restore:

Regularly back up data and create disaster recovery plans to recover from data loss or service disruptions.
Health Checks and Monitoring:

Implement health checks and monitoring to detect and respond to resource failures. AWS CloudWatch can be used to set up alarms and monitor resources.
DNS Failover:

Configure DNS failover mechanisms to route traffic to an alternative endpoint in case the primary endpoint becomes unavailable.
Active-Passive Setup:

For critical services, consider an active-passive setup where one instance or resource is active, and the others are passive standby resources ready to take over in case of failure.
Fault-Tolerant Architectures:

Design your applications and architectures to be fault-tolerant, meaning they can continue to operate with minimal disruption even when individual components fail.
Out-of-Region Failover:

Implement out-of-region failover for disaster recovery. If your primary region experiences a catastrophic failure, you can failover to a secondary region.
Remember that achieving high availability is a combination of architecture, design, and operational practices. It involves not only deploying resources redundantly but also managing and monitoring them to ensure continued availability. Cloud service providers like AWS offer a range of services and features to help you build highly available architectures in your VPC. The specific implementation details will depend on your application's requirements and the cloud platform you are using.






Security Groups.

In the context of cloud computing, a security group is a fundamental component used to control network traffic to and from virtual machines (VMs), instances, or resources within a cloud infrastructure. Security groups act as a virtual firewall, allowing you to define inbound and outbound traffic rules that determine which network traffic is allowed and which is denied for specific resources. These rules help ensure the security and isolation of your cloud resources.

Here are key characteristics and concepts related to security groups:

Inbound and Outbound Rules: A security group consists of a set of inbound and outbound traffic rules. Inbound rules control incoming traffic to the associated resources, while outbound rules control outgoing traffic from those resources.

Stateful Rules: Security groups typically use stateful rules, which means that if you allow incoming traffic from a specific source, responses to that traffic are automatically allowed. For example, if you allow incoming traffic on port 80 for a web server, the corresponding outbound responses are permitted.

Allow Rules: You define rules to explicitly allow certain types of traffic. For example, you can allow incoming SSH (Secure Shell) traffic on port 22 for system administration.

Deny by Default: By default, security groups deny all incoming traffic unless you specifically create rules to allow it. This principle follows the "deny by default" security model, which enhances security by minimizing exposure to unnecessary network traffic.

Source and Destination: Rules are defined based on source and destination. You specify the source (e.g., IP address, IP range, or another security group) and the destination (the security group itself or an instance associated with the security group).

Dynamic Membership: Security groups are associated with resources (e.g., VM instances or EC2 instances in AWS). When you launch a resource, you assign it to one or more security groups. Changes to the membership take effect immediately.

Group-Based: You can create and manage multiple security groups and assign them to different resources based on their specific security requirements. This allows you to group resources by their intended functions or roles and apply appropriate security policies.

Logging and Monitoring: Some cloud providers offer logging and monitoring capabilities to track security group rule changes and monitor network traffic for security analysis.

VPC or Network Isolation: In cloud environments like Amazon Web Services (AWS) or Azure, security groups are typically associated with Virtual Private Clouds (VPCs) or virtual networks. They help isolate resources within the same network.

Dynamic Scaling: Security groups can be used in conjunction with auto-scaling groups to dynamically adjust security group membership based on resource scaling requirements.

Security groups provide a flexible and powerful way to enhance the security of your cloud resources. They are essential for controlling network traffic and protecting your instances and services from unauthorized access and security threats in cloud environments. While the term "security group" is commonly associated with AWS, similar concepts exist in other cloud providers, often with different names. Always refer to the documentation of your specific cloud provider for detailed information on security group configuration and usage.





Root Module:

What It Is: The root module is the top-level directory or directory structure where your main Terraform configuration files reside. It serves as the entry point for your Terraform project.

Purpose: The root module is where you define variables, providers, and often your main resources or infrastructure components. It typically represents the primary environment or application you are managing with Terraform.

Directory Structure: The root module contains the main terraform block in your configuration files and is where you specify the backend configuration, variables, and data sources for your infrastructure.

Example: Your root module might define infrastructure components such as Virtual Private Clouds (VPCs), load balancers, or application servers for a specific environment.

Module:

What It Is: A module is a reusable and self-contained unit of Terraform configuration. It can represent a specific piece of infrastructure or a combination of resources, and it is encapsulated in its own directory.

Purpose: Modules are designed to promote code reusability, maintainability, and scalability. They allow you to encapsulate and abstract infrastructure components, making it easy to manage and deploy similar configurations across different environments.

Directory Structure: A module directory typically contains Terraform configuration files (.tf) that define resources, variables, outputs, and potentially sub-modules. Modules can be nested, allowing you to create complex infrastructure hierarchies.

Example: You might create a module for a web server cluster that includes load balancers, instances, and security groups. This module can be reused across multiple environments or applications.

Relationship:

The root module can use one or more modules. Modules are instantiated within the root module, and their outputs can be used as inputs for other modules or resources in the root module.

Modules can also use other modules, allowing you to build a hierarchy of modules where higher-level modules can depend on lower-level modules.

Reusability and Separation of Concerns:

The primary benefit of modules is that they promote code reusability and separation of concerns. You can develop and test modules independently and then compose them in various combinations within your root module.

Modules help keep your root module clean and focused on the overall architecture and configuration of your infrastructure.



acm

The Terraform configuration block is for provisioning and validating an SSL/TLS certificate using AWS Certificate Manager (ACM) and Amazon Route 53. This is a common setup for securing web applications by obtaining and validating SSL/TLS certificates. Let's break down the code block by block:

data "aws_route53_zone":

This block retrieves information about a Route 53 hosted zone. The name attribute is set to the domain name provided as a variable (var.domain_name), and private_zone is set to false, indicating that this is a public hosted zone.
resource "aws_acm_certificate":

This block requests an SSL/TLS certificate from ACM.
domain_name specifies the primary domain name for the certificate, provided as a variable (var.domain_name).
subject_alternative_names is an optional list of additional domain names to include in the certificate. It includes var.domain_name2.
validation_method is set to "DNS," indicating that DNS validation will be used to prove ownership of the specified domain names.
The lifecycle block ensures that the new certificate is created before the existing one is destroyed. This can help avoid service disruption during certificate renewal.
resource "aws_route53_record":

This block creates DNS records in the Route 53 hosted zone for domain validation. It creates one or more DNS records based on the domain_validation_options of the ACM certificate.
for_each iterates over the domain validation options of the ACM certificate.
allow_overwrite is set to true, allowing overwriting existing records if necessary.
The DNS record information is derived from the ACM certificate's domain_validation_options.
The zone_id is set to the ID of the Route 53 hosted zone obtained from the data "aws_route53_zone" block.
resource "aws_acm_certificate_validation":

This block validates the ACM certificate by checking DNS records in Route 53.
certificate_arn is set to the Amazon Resource Name (ARN) of the ACM certificate created earlier.
validation_record_fqdns is a list of fully qualified domain names (FQDNs) used for DNS validation. These FQDNs are obtained from the DNS records created in the previous aws_route53_record resource block.

The purpose of this Terraform configuration is to automate the process of obtaining an SSL/TLS certificate from ACM, creating the required DNS records in Route 53 for domain validation, and then validating the certificate. This is a common workflow for securing web applications by ensuring that the certificate is correctly associated with the specified domain names. The use of Terraform allows for infrastructure as code and automation of the certificate management process.




ANSIBLE
The Terraform configuration defines an AWS EC2 instance resource using the "aws_instance" resource type. Let's break down the attributes and their meanings:

resource "aws_instance" "ansible_server": This is declaring a new AWS EC2 instance resource. It will be managed by Terraform and given the resource name "ansible_server."

ami: The Amazon Machine Image (AMI) ID to be used for launching the EC2 instance. The value is obtained from the variable var.ami_redhat, which specifies the desired AMI for a Red Hat-based image.

instance_type: The EC2 instance type (e.g., t2.micro, m5.large) that you want to create. The value is obtained from the variable var.instance_type.

subnet_id: The ID of the subnet in which the EC2 instance will be launched. This is specified via the variable var.subnet_id.

associate_public_ip_address: A boolean value (in this case, true) indicating whether the EC2 instance should be assigned a public IP address when launched in a Virtual Private Cloud (VPC).

vpc_security_group_ids: An array of security group IDs that will be associated with the EC2 instance. The value is specified via the variable var.bastion-ansible-sg.

key_name: The name of the EC2 key pair to use for SSH access to the instance. It is specified through the variable var.key_name.

user_data: User data is a script or configuration data that is run when the instance is launched. It is provided from the local variable local.ansible_user_data.

tags: Tags are used to label and categorize the EC2 instance. In this case, a single tag named "Name" is set to the value from the variable var.tag-ansible.

This Terraform resource block is responsible for creating an EC2 instance with the specified configuration, including the choice of the AMI, instance type, subnet, security groups, key pair for SSH access, and user data for customizing the instance. Additionally, it sets a "Name" tag to help identify the instance. When you apply this Terraform configuration, it will create the specified EC2 instance according to the defined attributes and values.



ASG-PROD

The Terraform configuration provided defines an AWS Launch Template using the "aws_launch_template" resource type. AWS Launch Templates are used to specify the configuration settings for EC2 instances when they are launched as part of an Auto Scaling Group (ASG) or individually. 

The Launch Template provides a way to standardize the configuration of EC2 instances, making it easier to maintain consistency when launching multiple instances, especially within an Auto Scaling Group. When the template is referenced in an Auto Scaling Group, the specified configuration settings are applied to the instances launched by the group.

The variables used in this configuration are correctly defined and the referenced script file, "docker-script.sh," exists in the specified path. Additionally, the variables provided to the user data script are appropriately configured for specific use case.



ASG-STAGE

The Terraform configuration provided creates AWS resources for an Auto Scaling Group (ASG) and an associated Launch Template, along with an Auto Scaling Policy.
Overall, this configuration sets up an Auto Scaling Group with a Launch Template and a scaling policy that uses average CPU utilization as a metric to adjust the number of instances in the group. The Launch Template defines the instance configuration, while the scaling policy ensures that the group maintains a target CPU utilization level.









