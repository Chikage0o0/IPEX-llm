import os
import sys
import requests

if len(sys.argv) < 2:
    print("Usage: python script.py <repository_name>")
    sys.exit(1)

# 从命令行参数获取仓库名称
repository_name = sys.argv[1]
api_url = f"https://hub.docker.com/v2/repositories/{repository_name}/tags/latest"

response = requests.get(api_url)
if response.status_code == 200:
    tag_info = response.json()
    updated_at = tag_info.get("last_updated", None)
    if updated_at:
        github_output = os.getenv("GITHUB_OUTPUT")
        with open(github_output, "a") as f:
            f.write(f"latest_tag_updated_at={updated_at}\n")
    else:
        print("No updated date found for the latest tag")
        exit(1)
else:
    print(f"Failed to fetch data from Docker Hub: {response.status_code}")
    exit(1)
