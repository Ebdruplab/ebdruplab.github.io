#!/bin/bash
#Cleanup zone files
find . -name "Zone.Identifier" -type f -exec rm -f {} +
