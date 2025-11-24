#!/usr/bin/env python3
import json
import os
import sys
import time

import requests


def load_input():
    try:
        return json.load(sys.stdin)
    except Exception as e:
        log_error(f"Failed to parse JSON input: {e}")
        sys.exit(1)


def log_error(message):
    print(message, file=sys.stderr)


def resolve_iam_endpoint(use_private):
    endpoint = os.getenv("IBMCLOUD_IAM_API_ENDPOINT", "https://iam.cloud.ibm.com")
    endpoint = endpoint.replace("https://", "")

    if use_private and endpoint == "iam.cloud.ibm.com":
        return f"private.{endpoint}"
    return endpoint


def resolve_metrics_router_endpoint(region, use_private):
    metrics_endpoint = os.getenv(
        "IBMCLOUD_METRICS_ROUTING_API_ENDPOINT", "metrics-router.cloud.ibm.com"
    )
    metrics_endpoint = metrics_endpoint.replace("https://", "")

    if metrics_endpoint == "metrics-router.cloud.ibm.com":
        if use_private:
            return f"https://private.{region}.{metrics_endpoint}"
        else:
            return f"https://{region}.{metrics_endpoint}"

    return f"https://{metrics_endpoint}"


def fetch_iam_token(iam_endpoint, api_key):
    url = f"https://{iam_endpoint}/identity/token"

    payload = {
        "grant_type": "urn:ibm:params:oauth:grant-type:apikey",
        "apikey": api_key,
    }

    try:
        resp = requests.post(
            url,
            data=payload,
            headers={
                "Content-Type": "application/x-www-form-urlencoded",
                "Accept": "application/json",
            },
            timeout=10,
        )

        iam_json = resp.json()

    except Exception as e:
        log_error(f"Error fetching IAM token: {e}")
        sys.exit(1)

    if "errorMessage" in iam_json:
        log_error(iam_json["errorMessage"])
        log_error("Could not obtain an IAM access token")
        sys.exit(1)

    token = iam_json.get("access_token")
    if not token:
        log_error("IAM token missing from response")
        sys.exit(1)

    return token


def fetch_primary_metadata_region(base_url, iam_token):
    url = f"{base_url}/api/v3/settings"
    headers = {"Authorization": f"Bearer {iam_token}"}

    max_retries = 5
    retry_delay = 3

    for attempt in range(1, max_retries + 1):
        try:
            resp = requests.get(url, headers=headers, timeout=10)
            data = resp.json()
        except Exception:
            data = {}

        if "primary_metadata_region" in data:
            return data["primary_metadata_region"]

        log_error(f"Attempt {attempt} failed, retrying in {retry_delay}s...")
        time.sleep(retry_delay)

    log_error("`primary_metadata_region` could not be fetched after 5 attempts.")
    sys.exit(1)


def main():
    input_data = load_input()

    region = input_data["region"]
    api_key = input_data["IBM_API_KEY"]
    use_private_endpoint = json.loads(input_data["use_private_endpoint"])

    iam_endpoint = resolve_iam_endpoint(use_private_endpoint)
    base_url = resolve_metrics_router_endpoint(region, use_private_endpoint)

    iam_token = fetch_iam_token(iam_endpoint, api_key)
    primary_region = fetch_primary_metadata_region(base_url, iam_token)

    print(json.dumps({"primary_metadata_region": primary_region}))


if __name__ == "__main__":
    main()
