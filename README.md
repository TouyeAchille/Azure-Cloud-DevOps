In this project, we are creating an **Infrastructure as Code (IaC)** solution using **Packer** and **Terraform** to deploy a website with a load balancer.
Here’s a well-written, polished version of your instructions with clean formatting and a professional tone, keeping the CLI/DevOps style intact:

---

**Before we begin**, we will establish a policy to ensure that **all deployed Azure resources are tagged**.
This is a crucial first step that improves **organization**, enables **accurate resource tracking**, and simplifies **troubleshooting** when issues arise.

---

### **Step 1 – Navigate to the project folder**

Go to the directory containing your policy files:

```bash
cd "C1 - Azure Infrastructure Operations/project/"
```

---

### **Step 2 – Define the policy**

This command creates a new Azure Policy Definition based on the JSON rules in `policy.json` and parameters in `params.json`.
You can change the name of the policy (`-n`) if you wish.

```bash
az policy definition create \
  -n tagspolicyDefinition \
  --mode Indexed \
  --rules policy.json \
  --params params.json
```

---

### **Step 3 – Assign the policy**

Once defined, assign the policy so that it enforces tagging.
In this example, the policy ensures that the tag `Environment` is required for all resources:

```bash
az policy assignment create \
  --name require-tag-assignment \
  --policy tagspolicyDefinition \
  --params '{"tagName": {"value": "environment"}}'
```

This ensures that **no resource can be created without the required tag**, keeping your environment well-organized from day one.


-----

### Main Project Steps

The project is broken down into the following key phases:

1. **Creating a Packer Template:** We will use Packer to build a standardized server image that includes our application.
2. **Creating a Terraform Template:** We will define and provision the necessary Azure infrastructure using Terraform.
3. **Deploying the Infrastructure:** Finally, we will deploy the complete infrastructure using our Terraform template.

-----

### 1 - Creating a Packer Template

We use Packer to create a server image. This image is pre-configured with the application, ensuring consistency across all virtual machines. The project directory for Packer will have the following structure:

```
packer_azure/
├── builds.pkr.hcl
├── packer.pkr.hcl
├── README.md
├── server.json
├── sources.pkr.hcl
├── spvars.pkrvars.hcl
└── variables.pkr.hcl
```

To build the image with Packer, navigate to the `packer_azure` directory and run the following commands:

* `packer init .`
* `packer build .`

-----

### 2 - Creating a Terraform Template

We use Terraform to define and provision all the infrastructure needed for our website. The template will provision the following resources:

* An existing **Resource Group** will be utilized.
* A **Virtual Network** and a **Subnet** within that network will be created.
* A **Network Security Group** will be configured to allow access between VMs on the subnet while denying direct access from the internet.
* A **Network Interface** and a **Public IP** will be provisioned.
* A **Load Balancer** will be created, complete with a backend address pool and an address pool association for the network interface.
* A **Virtual Machine Availability Set** will be created to ensure high availability.
* Multiple **Virtual Machines** will be deployed using the server image you created with Packer.
* **Managed Disks** will be attached to the virtual machines.

A `variables.tf` file will be included to allow for easy configuration of the number of virtual machines and other deployment parameters.

The project directory for Terraform will have this structure:

```
terraform_azurerm/
├── main.tf
├── outputs.tf
├── providers.tf
├── solution.plan
├── terraform.tf
└── variables.tf
```

By default, the infrastructure will consist of two VMs, one VNet, and one subnet. You can customize the number of VMs from the command line.

To deploy the infrastructure, navigate to the `terraform_azurerm` directory and run these commands:

* `terraform init` : initializes your working directory by downloading the necessary plugins and modules for the providers you've declared in your configuration files
* `terraform fmt`  : reformats your Terraform configuration files
* `terraform validate` :  checks your configuration files for syntax errors and internal consistency
* `terraform plan --out solution.plan` (or `terraform plan -var counter="number of VM" --out solution.plan`) : command creates an execution plan.
* `Give your Password` 
* `terraform apply solution.plan`

Once the `terraform apply` command is complete, your infrastructure will be fully deployed.
