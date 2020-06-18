import socket
import json
import time
import sys
import requests

import testlib
curtime = "%s" % time.time()
logbody = {
    "e2etest": curtime
}

print(curtime)

fluentd_url = 'http://localhost:20003/any_http_tag'
headers = {'Content-Type': "application/json"}

resp = requests.post(fluentd_url, headers=headers, json=logbody)
if(resp.status_code != 200):
    print("failed to post to fluentd http endpoint: %s" % resp.text)
    sys.exit(1)

for n in range(0, 50):
    time.sleep(1)
    
    found = testlib.es_query.verify_term_value('e2etest', curtime)
    if(found):
        sys.exit(0)
    else:
        continue

print("timeout for getting the posted data.")
sys.exit(1)
