#!/bin/bash

# This script deletes all generatable files and folders you specify in the arrays below.

# ./<folder_domain>/<further_path>
declare -A folder_domains=(
    ["frontend"]="node_modules .svelte-kit"
    ["backend"]="vendor"
)

# .env
del_prvt_vars=true

# .pem
del_prvt_keys=true

if [ "$del_prvt_vars" = true ]; then
    echo deleting .env files
    rm -f ./*.env
else
    echo skipping deletion of .env files
fi

if [ "$del_prvt_keys" = true ]; then
    echo deleting .pem files
    rm -f ./*.pem
else
    echo skipping deletion of .pem files
fi

for folder in "${!folder_domains[@]}"; do
    echo "folder=$folder"

    IFS=' ' read -ra folder_paths <<<"${folder_domains[$folder]}"

    for path in "${folder_paths[@]}"; do
        echo "path=$path"
        folder_to_delete="$folder/$path"

        echo "deleting $folder_to_delete"
        rm -rf "$folder_to_delete"
    done
done

read -p "Press Enter to exit..."
