#!/bin/bash

. ./sripts/exportvars.sh

echo "Killing local test server"
ps ax | grep run_server.py | awk '{print $1}' | xargs kill

echo "Killing mongo database file"
pgrep mongod | xargs kill

echo "Activating virtual environment"
. ./venv/bin/activate

echo "Updating dependencies"
pip install -r requirements.txt

echo "Removing existing database files"
rm -r "$dbpath"

echo "Creating clean database folder"
mkdir -p "$dbpath"

echo "Starting mongo"
mongod --fork --logpath "$dblog" --port "$dbport" --dbpath "$dbpath"

echo "Waiting for mongod to run"
while ! nc -vz "$apihost" "$dbport"; do sleep 1; done
echo "Mongod successfully up"