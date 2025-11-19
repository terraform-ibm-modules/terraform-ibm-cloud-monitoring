#!/bin/bash
set -eo pipefail

input=$(cat)
REGION=$(echo "$input" | jq -r '.region')
USE_PRIVATE_ENDPOINT=$(echo "$input" | jq -r '.use_private_endpoint')
API_KEY=$(echo "$input" | jq -r '.IBM_API_KEY')

get_iam_endpoint() {
  endpoint="${IBMCLOUD_IAM_API_ENDPOINT:-https://iam.cloud.ibm.com}"
  endpoint="${endpoint#https://}"

  if [ "$USE_PRIVATE_ENDPOINT" = true ] && [ "$endpoint" = "iam.cloud.ibm.com" ]; then
      IBMCLOUD_IAM_API_ENDPOINT="private.${endpoint}"
  else
      IBMCLOUD_IAM_API_ENDPOINT="${endpoint}"
  fi
}

get_metrics_router_endpoint() {
  metrics_endpoint="${IBMCLOUD_METRICS_ROUTING_API_ENDPOINT:-metrics-router.cloud.ibm.com}"
  metrics_endpoint="${metrics_endpoint#https://}"

  if [ "$metrics_endpoint" = "metrics-router.cloud.ibm.com" ]; then
    if [ "$USE_PRIVATE_ENDPOINT" = true ]; then
        BASE_URL="https://private.${REGION}.${metrics_endpoint}"
    else
        BASE_URL="https://${REGION}.${metrics_endpoint}"
    fi
  else
    BASE_URL="https://${metrics_endpoint}"
  fi
}

get_iam_endpoint
get_metrics_router_endpoint

iam_response=$(curl --retry 3 -s -X POST "https://${IBMCLOUD_IAM_API_ENDPOINT}/identity/token" --header 'Content-Type: application/x-www-form-urlencoded' --header 'Accept: application/json' --data-urlencode 'grant_type=urn:ibm:params:oauth:grant-type:apikey' --data-urlencode "apikey=$API_KEY") # pragma: allowlist secret
error_message=$(echo "${iam_response}" | jq 'has("errorMessage")')

if [[ "${error_message}" != false ]]; then
    echo "${iam_response}" | jq '.errorMessage' >&2
    echo "Could not obtain an IAM access token" >&2
    exit 1
fi
IAM_TOKEN=$(echo "${iam_response}" | jq -r '.access_token')

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
