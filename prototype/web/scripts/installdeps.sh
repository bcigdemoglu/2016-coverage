#!/bin/bash

echo "Activating virtual environment"
. ./venv/bin/activate

echo "Updating dependencies"
pip install -r ./requirements.txt
