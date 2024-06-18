#!/bin/sh

# Read the file content into an environment variable
export LIFERAY_DXP_URL=https://$(cat /etc/liferay/lxc/dxp-metadata/com.liferay.lxc.dxp.main.domain)

# Optionally, you can echo the variable to verify it's set (for debugging purposes)
echo "LIFERAY_DXP_URL=$LIFERAY_DXP_URL"

# Read the PEM content into an environment variable
#export LIFERAY_DXP_PEM=$(python3 get_dxp_pem.py)

# Set the path to your YAML configuration file
YAML_FILE="/usr/local/apisix/conf/apisix.yaml"

# Get the base64 encoded public key using the Python script
PUBLIC_KEY=$(python3 get_dxp_pem.py)

# Check if the Python script succeeded
if [ $? -ne 0 ]; then
  echo "Failed to retrieve the base64 encoded public key"
  exit 1
fi

# Replace the placeholder in the YAML file with the base64 encoded public key
sed -i "s|%{{LIFERAY_DXP_PUBLIC_KEY}}|$PUBLIC_KEY|g" "$YAML_FILE"

echo "Placeholder replaced successfully in $YAML_FILE"

# Optionally, you can echo the PEM variable to verify it's set (for debugging purposes)
#echo "LIFERAY_DXP_PEM=$LIFERAY_DXP_PEM"

# Make it single line to make it easier with yaml
#export LIFERAY_DXP_PEM_SINGLELINE="$(echo "$LIFERAY_DXP_PEM" | tr -d '\n')"

#echo "LIFERAY_DXP_PEM_SINGLELINE=$LIFERAY_DXP_PEM_SINGLELINE"

# Start Apache APISIX
exec apisix start