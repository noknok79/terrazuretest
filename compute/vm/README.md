# Terraform VM Configuration

This directory contains Terraform configuration files for managing virtual machines.

## Prerequisites

- Ensure you have Terraform installed on your machine. You can download it from [Terraform's official website](https://www.terraform.io/downloads.html).
- Set up your cloud provider account (e.g., AWS, Azure, Google Cloud) and ensure you have the necessary permissions to create resources.

## Files Overview

- **main.tf**: The main configuration file where resources such as virtual machines and networking components are defined.
- **variables.tf**: This file declares input variables for the configuration, specifying their names, types, and default values.
- **outputs.tf**: Defines the output values that will be displayed after the infrastructure is created, such as the public IP address of the virtual machine.
- **providers.tf**: Specifies the required providers and their configurations for the Terraform setup.
- **terraform.tfvars**: Contains the values for the variables declared in `variables.tf`, allowing for easy customization.

## Usage Instructions

1. **Initialize the Terraform Configuration**  
   Run the following command to initialize the configuration and download the necessary provider plugins:
   ```
   terraform init
   ```

2. **Plan the Infrastructure**  
   To see what changes Terraform will make to your infrastructure, run:
   ```
   terraform plan
   ```

3. **Apply the Configuration**  
   To create the resources defined in your configuration, execute:
   ```
   terraform apply
   ```

4. **Destroy the Infrastructure**  
   If you need to remove all the resources created by Terraform, use:
   ```
   terraform destroy
   ```

## Additional Information

Refer to the official Terraform documentation for more details on specific commands and configurations.