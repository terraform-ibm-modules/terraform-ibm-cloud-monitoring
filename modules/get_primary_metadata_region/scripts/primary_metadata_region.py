#!/usr/bin/env python3
import json
import os
import sys
import time

import requests

def dbg(msg):
    print(f"[DEBUG] {msg}", file=sys.stderr)


def load_input():
    try:
        raw = sys.stdin.read()
        data = json.loads(raw)
        return data
    except Exception as e:
        log_error(f"Failed to parse JSON input: {e}")
        sys.exit(1)


def log_error(message):
    print(message, file=sys.stderr)


def resolve_metrics_router_endpoint(region, use_private):
    dbg(f"Running the function to get the metrics router endpoint(region={region}, use_private={use_private})")
    
    metrics_endpoint = os.getenv("IBMCLOUD_METRICS_ROUTING_API_ENDPOINT")
    dbg(f"environment input is: {metrics_endpoint}")

    if not metrics_endpoint:
        metrics_endpoint = "metrics-router.cloud.ibm.com"
    metrics_endpoint = metrics_endpoint.replace("https://", "")

    dbg(f"The final endpoint: {metrics_endpoint}")

    if metrics_endpoint == "metrics-router.cloud.ibm.com":
        if use_private:
            dbg(f"Using private endpoint: {metrics_endpoint}")
            return f"https://private.{region}.{metrics_endpoint}"
        else:
            dbg(f"Using public endpoint: {metrics_endpoint}")
            return f"https://{region}.{metrics_endpoint}"

    dbg(f"Final endpoint is: https://{metrics_endpoint}")
    return f"https://{metrics_endpoint}"


def fetch_primary_metadata_region(base_url, iam_token):
    url = f"{base_url}/api/v3/settings"
    dbg(f"url is: {url}")
    headers = {"Authorization": f"{iam_token}"}

    max_retries = 5
    retry_delay = 3

    for attempt in range(1, max_retries + 1):
        try:
            resp = requests.get(url, headers=headers, timeout=10)
            dbg(f"HTTP {resp.status_code} response: {resp.text}")
            data = resp.json()
            dbg(f"Parsed JSON: {data}")
        except Exception as e:
            dbg(f"Exception during request: {e}")
            data = {}

        if "primary_metadata_region" in data:
            dbg(f"Found primary_metadata_region: {data['primary_metadata_region']}")
            return data["primary_metadata_region"]

        log_error(f"Attempt {attempt} failed, retrying in {retry_delay}s...")
        time.sleep(retry_delay)

    log_error("`primary_metadata_region` could not be fetched after 5 attempts.")
    sys.exit(1)


def main():
    input_data = load_input()

    region = input_data["region"]
    dbg(f"region is : {region}")
    iam_token = input_data["iam_access_token"]
    use_private_endpoint = json.loads(input_data["use_private_endpoint"])
    dbg(f"private endpoint or not is : {use_private_endpoint}")

    base_url = resolve_metrics_router_endpoint(region, use_private_endpoint)
    dbg(f"Base URL: {base_url}")
    primary_region = fetch_primary_metadata_region(base_url, iam_token)
    dbg(f"Primary metadata region: {primary_region}")

    print(json.dumps({"primary_metadata_region": primary_region}))
    


if __name__ == "__main__":
    dbg("Script started")
    main()
