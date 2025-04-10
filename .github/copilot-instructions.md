# Copilot Instructions

- **@azure Rule - Use Azure Best Practices**: When generating code for Azure, running terminal commands for Azure, or performing operations related to Azure, invoke your `get_azure_best_practices` tool if available.
- **@workspace /fix**, automatically refer to the resources linked on these links https://registry.terraform.io/providers/hashicorp/azurerm/latest


## Resources
- [Github Repository](https://github.com)
- [AzureRM Terraform Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest)
- [Azure Terraform Developer Guide](https://learn.microsoft.com/en-us/azure/developer/terraform/)
- [Azure Terraform Overview](https://learn.microsoft.com/en-us/azure/developer/terraform/overview)
- [Azure Terraform GitHub Repository](https://github.com/Azure-Terraform)
- [Terraform on Azure - February 2024 Update](https://techcommunity.microsoft.com/blog/azuretoolsblog/terraform-on-azure-february-2024-update/4070567)
- [Terraform Questions on DevOps Stack Exchange](https://devops.stackexchange.com/questions/tagged/terraform?updated=true)
- [State Management in Terraform - Stack Overflow](https://stackoverflow.com/questions/59899067/state-management-in-terraform?updated=true)
- [Terraform Questions on Stack Overflow](https://stackoverflow.com/questions/tagged/terraform?updated=true)
- [TFSec Documentation](https://aquasecurity.github.io/tfsec/v1.28.1/)
- [TFSec Documentation 2](https://github.com/Codebytes/secure-terraform-on-azure)
- [Checkov Documentation](https://spacelift.io/blog/what-is-checkov)
- [Checkov Docs](https://github.com/bridgecrewio/checkov)
- [Checkov Azure Documentations](https://www.checkov.io/5.Policy%20Index/terraform.html)
- [Terraform Community for Azure](https://discuss.hashicorp.com/c/terraform-providers/tf-azure/34)

## General Best Practices
- **Resource Naming Conventions**: Use consistent and descriptive names for Azure resources to improve manageability and readability.
- **Resource Group Management**: Organize resources into appropriate resource groups based on their lifecycle and management requirements.
- **Tagging**: Apply tags to resources for better organization, cost management, and automation.

## Security Best Practices
- **Access Control**: Implement Role-Based Access Control (RBAC) to manage permissions and ensure least privilege access.
- **Network Security**: Use Network Security Groups (NSGs) and Azure Firewall to control inbound and outbound traffic.
- **Encryption**: Enable encryption for data at rest and in transit using Azure Key Vault and other encryption services.

## Performance Best Practices
- **Scaling**: Use Azure Autoscale to automatically adjust resources based on demand.
- **Monitoring**: Implement Azure Monitor and Application Insights to track performance and diagnose issues.
- **Optimization**: Regularly review and optimize resource configurations to ensure cost-effectiveness and performance.

## Compliance Best Practices
- **Policy Management**: Use Azure Policy to enforce organizational standards and assess compliance.
- **Auditing**: Enable auditing and logging for critical resources to track changes and access.
- **Governance**: Implement Azure Blueprints to define and deploy compliant environments.

## Specific Resource Best Practices
- **Virtual Machines**: Use managed disks, VM scale sets, and availability sets for high availability and performance.
- **Storage Accounts**: Implement lifecycle management policies and replication strategies for data durability.
- **Databases**: Use Azure SQL Database, Cosmos DB, and other managed database services for scalability and reliability.

## State Management
- **Backend Configuration**: Store Terraform state in Azure Blob Storage for shared access and consistency. Define backend configuration in separate files for different environments (e.g., `dev.backend.tfvars`, `prod.backend.tfvars`).

## Folder Structure
- **Main Configuration Files**: Use `main.tf` for the entry point and coordinator of all infrastructure logic.
- **Variables**: Use `variables.tf` to hold all the variables needed for the infrastructure. Create separate variable files for different environments (e.g., `dev.tfvars`, `prod.tfvars`).
- **Modules**: Use a `modules` folder to hold custom Terraform modules for reusable infrastructure configurations.

## Security Scanning with TFSec
- **Run TFSec Locally**: Before every Terraform deployment, run TFSec to identify potential security vulnerabilities and misconfigurations.
- **Exclude .terraform Directory**: Use the `--exclude-path` flag to exclude the `.terraform` directory from scans.
- **Severity Threshold**: Use `--minimum-severity HIGH` to focus on critical risks.
- **Save Reports**: Save TFSec reports using `--format json --out` for compliance tracking.
- **CI/CD Integration**: Integrate TFSec into CI/CD pipelines for continuous security.

## Security Scanning with Checkov
- **Run Checkov Locally**: Regularly run Checkov to scan Terraform configurations for security issues and compliance with best practices.
- **Custom Policies**: Define custom policies in Python or YAML to enforce organization-specific security standards.
- **CI/CD Integration**: Integrate Checkov into CI/CD pipelines to ensure continuous security and compliance checks.
- **Detailed Reporting**: Use Checkov's detailed reports to understand and remediate potential vulnerabilities.
