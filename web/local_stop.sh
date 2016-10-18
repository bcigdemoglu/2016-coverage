#!/bin/bash

echo "Killing local test server"
ps ax | grep run_server.py | awk '{print $1}' | xargs kill

echo "Killing mongo database file"
pgrep mongod | xargs kill

echo "Exiting virtual environment"
deactivate
