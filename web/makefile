#!/bin/bash

. ./local_run.sh

$endl

echo "----------------------------------------------------------------"
echo "Testing restful commands"
echo "----------------------------------------------------------------"

curl -v -X GET \
    -H "Content-Type: application/json" \
    -d '{}' \
    "$apiserver"/

$endl

curl -v POST \
    -H "Content-Type: application/json" \
    -d '{}' \
    "$apiserver"/testdb/populatedb

$endl

curl -v POST \
    -H "Content-Type: application/json" \
    -d '{"username":"ali", "password":"ali123"}' \
    "$apiserver"/login

$endl

curl -v POST \
    -H "Content-Type: application/json" \
    -d '{"username":"ali",
         "password":"ali123",
         "name":"Ertugrul"}' \
    "$apiserver"/register

$endl

curl -v POST \
    -H "Content-Type: application/json" \
    -d '{"username":"ali",
         "password":"ali122"}' \
    "$apiserver"/login

$endl

curl -v POST \
    -H "Content-Type: application/json" \
    -d '{"username":"ali",
         "password":"ali123"}' \
    "$apiserver"/login

$endl

curl -v -X GET \
    -H "Content-Type: application/json" \
    -d '{}' \
    "$apiserver"/

$endl

. ./local_stop.sh