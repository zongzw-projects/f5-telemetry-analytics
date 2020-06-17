import socket
import json
import time
import testlib
import sys

tcp_socket = None
conn_target = None

curtime = "%s" % time.time()
logbody = {
    "e2etest": curtime
}

print(curtime)

def tcp_connect(host, port):
    global tcp_socket
    global conn_target

    try:
        tcp_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        ipaddr = socket.gethostbyname(host)
        conn_target = (ipaddr, port)
        tcp_socket.connect(conn_target)
    except Exception as e:
        raise Exception("Cannot connect to %s:%d, %s" % (host, port, e.message))

def send_tcp(log):
    global tcp_socket
    msg = "%s\n" % log
    tcp_socket.sendall(str.encode(msg))

def tcp_close():
    tcp_socket.close()

tcp_connect('localhost', 20001)
send_tcp(json.dumps(logbody))
tcp_close()

for n in range(0, 50):
    time.sleep(1)
    
    found = testlib.es_query.verify_term_value('e2etest', curtime)
    if(found):
        sys.exit(0)
    else:
        continue

print("timeout for getting the posted data.")
sys.exit(1)
