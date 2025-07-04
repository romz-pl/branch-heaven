#!/bin/bash

# set -eE

main_branch=main


get_prompt() {
    local path="$1"
    echo "Generate unit test for file ${path}"
}

get_branch() {
    echo "claude-$(uuidgen)"
}


run_claude_code() {
    local path="$1"
    
    if [ ! -f "${path}" ]; then
        echo "Error: Required file '$path' not found" >&2
        git checkout ${main_branch}
        return 1
    fi
    
    local branch=$(get_branch)
    local prompt=$(get_prompt "$path")

    git checkout ${main_branch}
    git pull
    git checkout -b ${branch}

    echo ${path} > log-$(uuidgen).txt
    sleep 5s

    git add .
    git commit -m "Add unit test for file ${path}"
    git push
}

main() {
    git config push.autoSetupRemote true

    # Read each line and echo it
    while IFS= read -r line; do
        run_claude_code "$line"
    done < "$filename"

    git checkout $main_branch
}


# Check if filename argument is provided
if [ ! $# -eq 1 ]; then
    echo "Usage: $0 <filename>"
    exit 1
fi

filename="$1"

# Check if file exists
if [ ! -f "$filename" ]; then
    echo "Error: File '$filename' not found"
    exit 1
fi

main "$filename"


