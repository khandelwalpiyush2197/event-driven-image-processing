#!/bin/bash
set -e

echo "Zipping lambda_function.py..."
zip -r lambda.zip lambda_function.py

echo "Lambda package created: lambda.zip"
