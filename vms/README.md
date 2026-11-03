# Test Provisioner

A lightweight automation tool to quickly provision and configure a single Virtual Machine (VM) on Google Cloud Platform (GCP) using Ansible.

## 📋 Prerequisites

Before you begin, ensure you have the following installed on your local machine:
- [Google Cloud CLI (`gcloud`)](https://cloud.google.com/sdk/docs/install) installed and initialized.
- Git (to clone this repository).
- A GCP Project with billing enabled and the Compute Engine API activated.

## 🚀 First-Time Setup

If this is your first time using the provisioner on your machine, you need to set up the local environment and Ansible dependencies.

From the root of the repository, run:

```bash
./setup_ansible.sh
```

## 💻 Usage

To spin up a new VM and run the provisioning process, follow these steps:

1. **Authenticate with Google Cloud:**
   Refresh your application default credentials. You can run this without launching a browser (useful for remote environments):
   ```bash
   gcloud auth application-default login --no-launch-browser
   ```

2. **Run the Provisioner:**
   From the root of the repository, execute the provisioning script:
   ```bash
   ./test_provisioner.sh
   ```

3. **Run the Playbook Again (and again?):**
   From the root of the repository, run the ansible playbook until changes return zero:
   ```bash
   ./nimbus-eae-ansible/run_playbook_$VM_NAME.sh
   ```

## ⚙️ Configuration (Optional)
*Note: Update this section based on your specific script parameters.*

You can customize the VM deployment by editing the variables in the configuration files or passing environment variables before running the provisioner. 
- **Machine Type:** e.g., `e2-medium`
- **Region/Zone:** e.g., `us-central1-a`
- **Base Image:** e.g., Ubuntu 22.04 LTS

## 🧹 Cleanup

Remember to tear down your VM after testing to avoid incurring unnecessary cloud costs. You can delete the instance directly via the GCP Console or by using the `gcloud` CLI:

```bash
gcloud compute instances delete YOUR_INSTANCE_NAME --zone=YOUR_ZONE
```

## ❓ Troubleshooting

- **Permissions Issues:** Ensure the Google account you authenticated with has the `Compute Instance Admin` role (or equivalent) in your target GCP project.
- **Ansible Errors:** If the script fails during the Ansible phase, verify that your SSH keys are correctly configured and that the target VM allows SSH traffic (port 22) from your IP address.
