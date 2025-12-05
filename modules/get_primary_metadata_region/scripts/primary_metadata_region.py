#!/usr/bin/env python3
import json
import os
import sys
import time
import http.client
import urllib.parse


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

    metrics_endpoint = os.getenv("IBMCLOUD_METRICS_ROUTING_API_ENDPOINT")

    if not metrics_endpoint:
        metrics_endpoint = "metrics-router.cloud.ibm.com"
    metrics_endpoint = metrics_endpoint.replace("https://", "")

    if metrics_endpoint == "metrics-router.cloud.ibm.com":
        if use_private:
            return f"https://private.{region}.{metrics_endpoint}"
        else:
            return f"https://{region}.{metrics_endpoint}"

    return f"https://{metrics_endpoint}"


def http_get(url, headers=None, timeout=10):
    headers = headers or {}
    parsed = urllib.parse.urlparse(url)
    metricsrouterconn = http.client.HTTPSConnection(parsed.hostname, parsed.port, timeout=timeout)
    
    try:
        metricsrouterconn.request("GET", parsed.path, headers=headers)
        response = metricsrouterconn.getresponse()
        metrics_router_response = response.read().decode("utf-8")
        return response.status, metrics_router_response
    
    except Exception as e:
        raise
    
    finally:
        metricsrouterconn.close()

def fetch_primary_metadata_region(base_url, iam_token):
    url = f"{base_url}/api/v3/settings"
    headers = {"Authorization": iam_token}

    max_retries = 5
    retry_delay = 3

    for attempt in range(1, max_retries + 1):
        try:
            status, body = http_get(url, headers=headers, timeout=10)
            data = json.loads(body)

        except Exception as e:
            data = {}
            status = str(e)

        if "primary_metadata_region" in data:
            return data["primary_metadata_region"]

        log_error(f"Attempt {attempt} failed (status {status}), retrying in {retry_delay}s...")
        time.sleep(retry_delay)

    log_error("`primary_metadata_region` could not be fetched after 5 attempts.")
    sys.exit(1)


def main():
    input_data = load_input()

    region = input_data["region"]
    iam_token = input_data["iam_access_token"]
    use_private_endpoint = json.loads(input_data["use_private_endpoint"])

    base_url = resolve_metrics_router_endpoint(region, use_private_endpoint)
    primary_region = fetch_primary_metadata_region(base_url, iam_token)

    print(json.dumps({"primary_metadata_region": primary_region}))


if __name__ == "__main__":
    main()
