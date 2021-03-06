{
    "timestamp": "$DATE_YYYY-$DATE_MM-${DATE_DD}T${TIME_HMS}.000${TIME_OFFSET}",
    "vs_name": "$VIRTUAL_NAME",
    "client-ip": "${X-Forwarded-For}", 
    "host": "$Host", 
    "user-agent": "${User-agent}", 
    "cookie": "$Cookie", 
    "method": "$HTTP_METHOD", 
    "uri": "$HTTP_URI", 
    "username": "$Username", 
    "content-type": "${Content-Type}", 
    "server-ip": "$SERVER_IP", 
    "latency": $RESPONSE_MSECS, 
    "status": "$HTTP_STATCODE"
}