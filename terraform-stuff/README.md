# terraform-stuff

# Prereqs

- Mac (running macOS Catalina)
- AWS Account

# Installation

## Step 1 - Clone this Repo

## Step 2 - Install Terraform CLI (macOS Catalina)

1. Download Terraform [here](https://www.terraform.io/downloads.html)
2. Open Terminal
3. Run `echo $PATH` and note one of the listed locations (e.g., `/usr/local/bin`)
4. Run `mv ~/Downloads/terraform /usr/local/bin/`, where `/usr/local/bin/` is one of the listed locations from Step 3
5. Run `terraform -help` to verify the installation

## Step 3 - Create Temporary User in AWS IAM

1. Log into the AWS Management Console
2. Go to IAM
3. Select **Add user**

- User name*: delete.me
- Select AWS Access Type: Programmatic access

4. Select **Next: Permissions**
5. Select **Attach existing policies directly**
6. Select **AdministratorAccess**
7. Select **Next: Tags**

- Key: Name
- Value: Delete Me

8. Select **Next: Review**
9. Select **Create user**
10. Select **Download .csv**

## Step 4 - Add Temporary User IAM Credentials to main.tf

1. Open .csv from Step 3, Step 10
2. Copy Access key ID and paste into the double quote in line 13
3. Copy Secret access key and paste into the double quote in line 15

## Step 5 - Deploy Apache Web Server to AWS EC2

1. `cd` into the same dir as the `main.tf` file
2. Run `terraform init`
3. Run `terraform plan`
4. Run `terraform apply`
5. When asked, type in a value of `yes`
6. Copy the URL from the "Outputs" and paste it into your browser (for DoD users, please ditch IE and use Chrome)
7. Run `terraform destroy` when you are done
8. When asked, type in a value of `yes`
9. Delete Temporary IAM User (delete.me) from Step 3

# Troubleshooting

- If the site does not come up right away, you may need to add an **Inbound rule** to your **default** Security Group, opening up **TCP port 80 (HTTP)** to either **Anywhere** or **My IP**.

# Support