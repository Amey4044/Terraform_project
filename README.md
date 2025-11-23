🚀 Infrastructure Automation Lab using Terraform, Vagrant & Ansible

This project simulates a local on-prem datacenter environment using Terraform, Vagrant, VirtualBox, and Ansible.
It automatically provisions virtual machines and configures services such as Nginx through Ansible playbooks.


📁 Project Structure

![terraform_7](https://github.com/user-attachments/assets/d5257d5d-b1e6-48da-aab7-dd1d98de9ace)


🧰 Technologies Used

    | Tool           | Purpose                                         
| -------------- | --------------------------------------------------- |
| **Terraform**  | Defines VM provisioning (local-exec to Vagrant)     |
| **Vagrant**    | Creates VirtualBox VMs                              |
| **VirtualBox** | Hypervisor for local VMs                            |
| **Ansible**    | Automates Nginx installation & server configuration |
| **Linux**      | Ubuntu VM images                                    |


🏗 Architecture Diagram (On-Prem Simulation)

![terraform_6](https://github.com/user-attachments/assets/f85c9a41-b0d0-4448-9b56-131d2b8a5423)



📸 Screenshots

🔹 Terraform Apply – VM Provisioning
![terraform_1](https://github.com/user-attachments/assets/38d2d3cd-bdde-4db7-b0e4-4b59560ad9c1)

🔹 Nginx running on the Web VM
![terraform_2](https://github.com/user-attachments/assets/a947e2f9-dc91-47e3-a57d-05e907e0a465)

🔹 PostgreSQL or supporting VM output
![terraform_3](https://github.com/user-attachments/assets/599b76f8-61cc-4e9f-b2f0-f2bf7eccb1e7)

🔹 Resource replacement triggered by file changes
![terraform_4](https://github.com/user-attachments/assets/6dd6f323-396c-438f-8cde-64f1b297a945)

🔹 Multi-VM provisioning complete
![terraform_5](https://github.com/user-attachments/assets/179f3693-a5ad-4c7d-a4ed-a56d11bab5b2)

▶️ How to Run This Project

1. Enter the terraform directory
cd terraform-gcp-ansible/terraform

2. Initialize Terraform
terraform init -reconfigure

3. Apply (Provision VM + Configure via Ansible)
terraform apply -auto-approve

4. Test the Deployment

Open your browser:

🌐 http://localhost:8082
 → Nginx running on VM

🧹 Destroy Everything
terraform destroy -auto-approve

⭐ Key Learnings

Infrastructure as Code using Terraform

VM automation using Vagrant + VirtualBox

Configuration management with Ansible

Multi-VM provisioning

Understanding local on-prem style automation

Hands-on DevOps workflows end-to-end
