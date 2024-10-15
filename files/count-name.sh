#!/bin/bash

echo "Choose an option:"
echo "1. List all file counts by name"
echo "2. List file counts by extension"
read -p "Enter your choice (1 or 2): " choice

if [ "$choice" -eq 1 ]; then
    echo "Listing all file counts by name..."
    # find . -type f -exec basename {} \; | sort | uniq -c | sort -nr
    find . -type f -printf '%f\n' | sed --regexp-extended 's/(^.\.)|(^[^.]$)//' | sort | uniq --count | sort --numeric-sort --reverse
elif [ "$choice" -eq 2 ]; then
    echo "Listing file counts by extension..."
    # find . -type f -name "*.*" | awk -F. '{print $NF}' | sort | uniq -c | sort -nr
    find . -type f | sed 's/.*\.//' | sort | uniq -c | sort -rn
else
    echo "Invalid choice, please try again."
fi
