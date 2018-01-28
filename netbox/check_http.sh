#!/bin/bash
echo "## listening ports:"
netstat -tlpn

echo "## Check gunicorn port 8001:"
curl -fsS http://localhost:8001/ > /dev/null
if [ $? -eq 0 ] ; then
  echo " OK" 
else
  curl -vsS http://localhost:8001/
fi

echo "## Check nginx port 8080:"
curl -fsS http://localhost:8080/ > /dev/null
if [ $? -eq 0 ] ;then 
  echo " OK"
else
  curl -vsS http://localhost:8080/
fi
