import time
import socket
import json
import requests
import sys

import testlib

conn_target = None
udp_socket = None

curtime = "%s" % time.time()
logbody = {
    "e2etest": curtime
}

print(curtime)

def udp_connect(host, port):
    global conn_target
    global udp_socket

    udp_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    ipaddr = socket.gethostbyname(host)
    conn_target = (ipaddr, port)


def send_udp(log):
    global udp_socket, conn_target
    udp_socket.sendto(str.encode(log), conn_target)

def udp_close():
    udp_socket.close()

udp_connect('localhost', 20002)
send_udp(json.dumps(logbody))
udp_close()

for n in range(0, 50):
    time.sleep(1)
    
    found = testlib.es_query.verify_term_value('e2etest', curtime)
    if(found):
        sys.exit(0)
    else:
        continue

print("timeout for getting the posted data.")
sys.exit(1)
