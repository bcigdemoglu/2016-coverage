#!/bin/bash

. ./local_run.sh

$endl

echo "----------------------------------------------------------------"
echo "Testing restful commands"
echo "----------------------------------------------------------------"

curl -v -X GET \
    -H "Content-Type: application/json" \
    -d '{}' \
    "$apiserver"/find

$endl

curl -v -X GET \
    -H "Content-Type: application/json" \
    -d '{}' \
    "$apiserver"/ins

$endl

curl -v -X GET \
    -H "Content-Type: application/json" \
    -d '{}' \
    "$apiserver"/find

$endl

. ./local_stop.sh