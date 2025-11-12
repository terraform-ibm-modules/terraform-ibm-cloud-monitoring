#!/bin/bash
set -euo pipefail

input=$(cat)
IBM_API_KEY=$(echo "$input" | jq -r '.IBM_API_KEY')
REGION=$(echo "$input" | jq -r '.region')
USE_PRIVATE_ENDPOINT=$(echo "$input" | jq -r '.use_private_endpoint')

get_iam_endpoint() {
  IAM_ENDPOINT="${IBM_IAM_ENDPOINT:-https://iam.cloud.ibm.com}"
  IAM_ENDPOINT=${IAM_ENDPOINT#https://}
}

get_metrics_router_endpoint() {
  metrics_endpoint="${IBM_CLOUD_METRICS_ENDPOINT:-metrics-router.cloud.ibm.com}"

  if [[ "$USE_PRIVATE_ENDPOINT" == "true" ]]; then
    BASE_URL="https://private.${REGION}.${metrics_endpoint}"
  else
    BASE_URL="https://${REGION}.${metrics_endpoint}"
  fi
}

get_iam_endpoint
get_metrics_router_endpoint

# Obtain IAM token
IAM_TOKEN=$(curl -s -X POST "https://${IAM_ENDPOINT}/identity/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=urn:ibm:params:oauth:grant-type:apikey&apikey=${IBM_API_KEY}" \
  | jq -r '.access_token')

if [[ -z "$IAM_TOKEN" || "$IAM_TOKEN" == "null" ]]; then
  echo "Error: Failed to obtain IAM token" >&2
  exit 1
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

primary_region=$(echo "$response" | jq -r '.primary_metadata_region // empty')

if [[ -z "$primary_region" ]]; then
  echo "Warning: primary_metadata_region is empty" >&2
fi

jq -n --arg primary_region "$primary_region" '{primary_metadata_region: $primary_region}'
