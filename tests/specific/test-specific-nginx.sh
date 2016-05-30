#!/bin/bash

if [ "$DOCKER_IP" == "" ]; then
  DOCKER_IP="$(dinghy ip)"
fi

################################################################################
# Run web server tests on apache image
################################################################################

echo ""
echo "Running web server tests:"
echo ""

# Create a test file
mkdir -p $(pwd)/tmp/www/pub
echo "OK" > $(pwd)/tmp/www/pub/index.html

# Start the web server, mounting the directory containing our test file
docker run -h test.host -d -v $(pwd)/tmp/www:/var/www/magento -p $DOCKER_IP:8888:80 testimage || exit 1
echo ""

# Spent up to a minute trying to connect to the web server
max_attempts=12
timeout=5
attempt=0

while (( $attempt < $max_attempts ))
do
 curl $DOCKER_IP:8888/index.html | tee /tmp/test.log
 grep "OK" /tmp/test.log > /dev/null
 curl_result=$?

 rm -f /tmp/test.log

 # Wait for a zero exit code before stopping
 if [[ $curl_result == 0 ]]
 then
   break
 fi

 echo ""
 echo "Failed to connect to web server. Retrying in $timeout.."
 echo ""

 sleep $timeout
 attempt=$(( attempt + 1 ))
done

if [ "$attempt" -eq "$max_attempts" ]; then
 echo ""
 echo "Reached maximum web server connnection attempts"
 echo ""
 exit 1
fi
