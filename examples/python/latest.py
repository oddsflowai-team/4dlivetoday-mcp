"""Print the newest 1st/2nd/3rd prize of every operator. Standard library only."""
import json
import urllib.request

URL = "https://4dlivetoday.com/api/v1/latest"

with urllib.request.urlopen(URL, timeout=20) as r:
    body = json.load(r)

for d in body["data"]["results"]:
    print(f'{d["date"]}  {d["operator_name"]:<22} 1st {d["first"]}  2nd {d["second"]}  3rd {d["third"]}')

print("\n" + body["attribution"])
