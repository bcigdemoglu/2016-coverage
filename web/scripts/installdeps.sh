#!/bin/bash

echo "Creating virtual environment"
virtualenv venv

echo "Activating virtual environment"
. ./venv/bin/activate

echo "Updating dependencies"
pip install -r ./requirements.txt
