#!/bin/bash
# Exit immediately if a command exits with a non-zero status
set -e 

ANSIBLE_DIR="nimbus-eae-ansible"
if [[ ! -d $ANSIBLE_DIR ]]; then 
    echo " Error: $ANSIBLE_DIR does not exist"
    echo " To fix this, run the setup_ansible.sh script."
    echo " Exiting."
    exit
fi

# --- Configuration ---
VM_NAME="polly-test-$(date +%Y%m%d-%H%M)"
ZONE="us-central1-b"
PROJECT="wcoss-eae-project-1"
PLAYBOOK="playbooks/compute_nodes.yml"
INVENTORY_FILE="dynamic_test_inventory.yml"

# Inject the dynamic VM name into the JSON template
sed "s/REPLACE_WITH_VM_NAME/$VM_NAME/g" test_spec.json > "run_$VM_NAME.json"

echo "====================================================="
echo " Starting Test VM Provisioning: $VM_NAME"
echo "====================================================="

# 1. Create the VM
echo "-> Spinning up GCP instance..."
# If you have the exported REST JSON payload from the GCP console, the standard 
# way to use it in bash is by passing it to the REST API via curl:

# Call the REST API
curl -X POST -H "Authorization: Bearer $(gcloud auth print-access-token)" \
     -H "Content-Type: application/json" \
     -d @"run_$VM_NAME.json" \
     "https://compute.googleapis.com/compute/v1/projects/$PROJECT/zones/$ZONE/instances"

# 2. Wait for boot and inject SSH keys
echo "-> Waiting for VM to boot and injecting SSH keys via internal IP..."
# This loop uses gcloud to repeatedly attempt an SSH connection. 
# Once it succeeds, we know two things: the VM is booted, AND Google has 
# successfully injected ~/.ssh/google_compute_engine.pub into the VM's metadata.
until gcloud compute ssh "$VM_NAME" --project="$PROJECT" --zone="$ZONE" --internal-ip --command="echo 'SSH is up!'" 2>/dev/null; do
    echo "   ...waiting for SSH..."
    sleep 5
done

# 3. Generate dynamic Ansible inventory
echo "-> Changing directory to ./$ANSIBLE_DIR..."
cd $ANSIBLE_DIR
echo "-> activating ansible venv..."
source .venv-ansible/bin/activate
echo "-> Generating temporary Ansible inventory..."
cat << EOF > "$INVENTORY_FILE"
all:
  children:
    compute:
      hosts:
        $VM_NAME:
          ansible_user: $(whoami)
          zone: $ZONE
          ansible_ssh_private_key_file: ~/.ssh/google_compute_engine
          ansible_ssh_common_args: '-F /dev/null -o StrictHostKeyChecking=no'
    compute_original:
      hosts:
        $VM_NAME:
          ansible_user: $(whoami)
EOF

# 4. Run the Ansible Playbook
echo "-> Executing Ansible Playbook..."

# pass the zone as an extra var for the Lustre tasks.
ANSIBLE_INVENTORY_ENABLED=yaml,ini,gcp_compute \
ansible-playbook -i "$INVENTORY_FILE" "$PLAYBOOK" \
    --diff \
    -e "zone=$ZONE"

cat << EOF > "run_playbook_$VM_NAME.sh"
cd $ANSIBLE_DIR
source .venv-ansible/bin/activate
ANSIBLE_INVENTORY_ENABLED=yaml,ini,gcp_compute \
ansible-playbook -i "$INVENTORY_FILE" "$PLAYBOOK" \
    --diff \
    -e "zone=$ZONE"
EOF
chmod +x run_playbook_$VM_NAME.sh

echo "====================================================="
echo " Provisioning Complete!"
echo " You can SSH into the new VM using:"
echo " ssh -i ~/.ssh/google_compute_engine $VM_NAME"
echo "====================================================="
echo " Rerun the ansible playbook until output shows "changed: 0" as follows:"
echo " ./$ANSIBLE_DIR/run_playbook_$VM_NAME.sh"
echo "====================================================="
