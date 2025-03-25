#!/bin/bash

declare -A plans=(
  ["compute/vmscalesets/vmscalesets.tfvars"]="vmscalesets.plan"
  ["databases/azsqldbs/azsql.tfvars"]="azsqldbs.plan"
  ["compute/aks/aks.tfvars"]="akscluster.plan"
  ["compute/vm/vm.tfvars"]="computevm.plan"
)

for tfvars in "${!plans[@]}"; do
  terraform plan -var-file="$tfvars" --out="${plans[$tfvars]}" --input=false
done