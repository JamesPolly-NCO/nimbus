#!/bin/bash
# Get our ansible repo and don't version control it here:
git clone git@github.com:redlineperf/nimbus-eae-ansible.git
cd nimbus-eae-ansible/
rm -rf .git

# Make a venv
python3 -m venv .venv-ansible
source .venv-ansible/bin/activate
pip install --upgrade pip
pip install -r ../ansible_requirements.txt
ansible-galaxy collection install -r requirements.yml

echo "Setup complete!"

echo "====================================================="
echo " Setup Complete!"
echo " Run the following command to authenticate:"
echo " gcloud auth application-default login --no-launch-browser"
echo "====================================================="

