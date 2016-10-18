#!/bin/bash

. ./sripts/exportvars.sh

. ./local_stop.sh

. ./scripts/installdeps.sh

echo "Removing existing database files"
rm -r "$dbpath"

echo "Creating clean database folder"
mkdir -p "$dbpath"

echo "Starting mongo"
mongod --fork --logpath "$dblog" --port "$dbport" --dbpath "$dbpath"

echo "Waiting for mongod to run"
while ! nc -vz "$apihost" "$dbport"; do sleep 1; done
echo "Mongod successfully up"

echo "Running test server"
python "$testscript" &

echo "Waiting for the test server to run"
while ! nc -vz "$apihost" "$apiport"; do sleep 1; done
echo "Test server successfully up"
