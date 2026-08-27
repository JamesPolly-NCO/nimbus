#!/bin/bash
# Get some VM metadata, and see the docs below:
# https://docs.cloud.google.com/compute/docs/metadata/predefined-metadata-keys#instance-metadata

# get the VM instance name
instance_name=$(curl -s http://metadata.google.internal/computeMetadata/v1/instance/name -H Metadata-Flavor:Google)

# get the VM instance hostname
instance_hostname=$(curl -s http://metadata.google.internal/computeMetadata/v1/instance/hostname -H Metadata-Flavor:Google)

# get the VM instance zone
instance_zone=$(curl -s http://metadata.google.internal/computeMetadata/v1/instance/zone -H Metadata-Flavor:Google)

echo $instance_name
echo $instance_hostname
echo $instance_zone

