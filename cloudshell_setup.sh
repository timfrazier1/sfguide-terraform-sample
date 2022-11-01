#!/usr/bin/env bash

set -e

echo "Setting up your Cloud Shell."

# Create a custom bin/ directory
mkdir -p "$HOME"/bin

minRequiredVersion="1.1.0"
versionTwo="2.0.0"

# Install Terraform if it is not installed
if ! type terraform 2>&1; then
    curl https://releases.hashicorp.com/terraform/${minRequiredVersion}/terraform_${minRequiredVersion}_linux_amd64.zip --output "$HOME"/bin/terraform.zip
    unzip "$HOME"/bin/terraform.zip -d "$HOME"/bin
    rm "$HOME"/bin/terraform.zip
else
    echo "-> Terraform is already installed!"
    currentVersion="$(terraform version | head -n1 | cut -d" " -f2 | cut -d"v" -f2)"
    # if the installed version matches the minimum required version, do nothing
    if [ "$minRequiredVersion" != "$currentVersion" ]; then
      # check if the installed terraform version is lower than the minimum required version &
      # install the minRequiredVersion if it is
      if [ "$(printf '%s\n' "$minRequiredVersion" "$currentVersion" | sort -V | head -n1)" = "$currentVersion" ]; then
          echo "Installed version: ${currentVersion} is lower than required version: ${minRequiredVersion}."
          echo "-> Installing Terraform version v${minRequiredVersion}..."
          curl https://releases.hashicorp.com/terraform/${minRequiredVersion}/terraform_${minRequiredVersion}_linux_amd64.zip --output "$HOME"/bin/terraform.zip
          unzip -o "$HOME"/bin/terraform.zip -d "$HOME"/bin
          rm "$HOME"/bin/terraform.zip
      # check if the installed terraform version is higher than v1. Terraform v1 is backwards
      # compatible with 1.1.0. If higher than v1 install the minRequiredVersion
      elif [ "$(printf '%s\n' "$versionTwo" "$currentVersion" | sort -V | head -n1)" = "$versionTwo" ]; then
          echo "Installed version: ${currentVersion} is higher than our current supported version."
          echo "-> Installing Terraform version v${minRequiredVersion}..."
          curl https://releases.hashicorp.com/terraform/${minRequiredVersion}/terraform_${minRequiredVersion}_linux_amd64.zip --output "$HOME"/bin/terraform.zip
          unzip -o "$HOME"/bin/terraform.zip -d "$HOME"/bin
          rm "$HOME"/bin/terraform.zip
      fi
    fi
fi

echo ""
echo "Your shell is almost ready. Type 'exit' then hit enter before running any further commands. Open the Cloud Shell again and the environment will be ready for use!"
