#!/bin/bash
# Exit immediately if a command exits with a non-zero status
set -e

echo "Setting up Python virtual environment..."

# Check if python3 is installed
if ! command -v python3 &> /dev/null; then
    echo "Error: Python3 is required but not installed."
    exit 1
fi

# Create virtual environment in a folder named 'venv'
python3 -m venv nimbus_eae_venv

# Activate and install dependencies
source nimbus_eae_venv/bin/activate
python3 -m pip install --upgrade pip

if [ -f "requirements.txt" ]; then
    pip install -r requirements.txt
    echo "Dependencies installed successfully."
else
    echo "No requirements.txt found, skipping dependency installation."
fi

echo "========================================"
echo "Setup complete! To activate the environment, run:"
echo "source nimbus_eae_venv/bin/activate"
