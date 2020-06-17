import requests
import json

def verify_term_value(term, value):
    es_url = 'http://localhost:9200/general-*/_search'
    headers = {'Content-Type': "application/json"}
    body_json = {
        "query": { 
            "bool": {
                "filter": [
                    {"exists": {"field": term}},
                    {"term": {term: value}}
                ]
            }
        }
    }
    print(body_json)
    try:
        resp = requests.get(
            es_url, 
            headers=headers, 
            data=json.dumps(body_json)
        )
    except Exception as e:
        print("Failed to get %s: %s" % (es_url, e.message))
        return False
    else:    
        if resp.status_code == 200:
            res = resp.json()
            # print(json.dumps(res, indent=2))
            str_res = json.dumps(res)
            if str_res.find(value) == -1:
                print("doesn't find the post data in ES %s" % str_res)
                return False
            else:
                print("got the specific data: %s" % str_res)
                return True
        else:
            print("es response with: %s, %s" % (resp.reason, json.dumps(resp.text)))
            return False
