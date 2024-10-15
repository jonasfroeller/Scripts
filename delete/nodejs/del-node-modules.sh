#!/bin/bash

# Deletes all node_modules folders in the current directory and its subdirectories.

find . -name "node_modules" \
    -type d -prune -exec rm -rf '{}' \;

read -p "Press Enter to exit..."
