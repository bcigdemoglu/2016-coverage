#!/bin/bash

export dbpath="./data/db"
export logpath="./log"
export dblog="./log/mongod.log"
export dbport="27017"
export apiport="5000"
export apihost="127.0.0.1"
export apiserver="http://$apihost:$apiport"
export testscript="./run_server.py"

export endl="echo -e \n\n"

echo "Variables exported."
