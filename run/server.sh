#!/usr/bin/env bash
set -eu
trap exit SIGINT SIGTERM

# Close any previous instances
script_name=${BASH_SOURCE[0]}

for pid in $(pidof -x $script_name); do
  if [ $pid != $$ ]; then
    kill -15 $pid 2> /dev/null
    wait $pid 2> /dev/null
  fi
done

# Serve the page
HTML="<HTML><HEAD><STYLE>body {  color: white; background-color: lightblue; } </STYLE></HEAD><BODY><H1><CENTER>$2</CENTER></H1></BODY></HTML>"
LENGTH=$(echo "$HTML" | wc -c);

RESPONSE="HTTP/1.1 200 OK\nContent-Length: ${LENGTH}\nConnection: close\n\n$HTML\n\n"

while true; do
  echo -en "$RESPONSE" | nc -N -lp "${1:-8080}";
done
