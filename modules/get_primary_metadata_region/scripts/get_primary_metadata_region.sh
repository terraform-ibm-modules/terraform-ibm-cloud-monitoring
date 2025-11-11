#!/bin/bash
set -euo pipefail

input=$(cat)
IBM_API_KEY=$(echo "$input" | jq -r '.IBM_API_KEY')
REGION=$(echo "$input" | jq -r '.region')
USE_PRIVATE_ENDPOINT=$(echo "$input" | jq -r '.use_private_endpoint')


if [[ -z "$IBM_API_KEY" || "$IBM_API_KEY" == "null" ]]; then
  echo "Error: IBM_API_KEY is missing" >&2
  exit 1
fi

if [[ -z "$REGION" || "$REGION" == "null" ]]; then
  echo "Error: region is missing" >&2
  exit 1
fi

IAM_TOKEN=$(curl -s -X POST "https://iam.cloud.ibm.com/identity/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=urn:ibm:params:oauth:grant-type:apikey&apikey=${IBM_API_KEY}" \
  | jq -r '.access_token')

if [[ -z "$IAM_TOKEN" || "$IAM_TOKEN" == "null" ]]; then
  echo "Error: Failed to obtain IAM token" >&2
  exit 1
fi

if [[ "$USE_PRIVATE_ENDPOINT" == "true" ]]; then
  BASE_URL="https://${REGION}.metrics-router.private.cloud.ibm.com"
else
  BASE_URL="https://${REGION}.metrics-router.cloud.ibm.com"
fi

URL="${BASE_URL}/api/v3/settings"

max_retries=5
retry_delay=3

for ((i=1; i<=max_retries; i++)); do
  response=$(curl -s -X GET "$URL" -H "Authorization: Bearer ${IAM_TOKEN}" || true)
  if echo "$response" | jq -e '.primary_metadata_region' >/dev/null; then
    break
  fi
  echo "Attempt $i failed, retrying in ${retry_delay}s..." >&2
  sleep "$retry_delay"
done

# Extract region value
primary_region=$(echo "$response" | jq -r '.primary_metadata_region // empty')

if [[ -z "$primary_region" ]]; then
  echo "Error: primary_metadata_region not found in response" >&2
  exit 1
fi

# Output valid JSON for Terraform
jq -n --arg primary_region "$primary_region" '{primary_metadata_region: $primary_region}'
