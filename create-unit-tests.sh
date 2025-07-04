#!/bin/bash

# Turn on command echoing
set -x

main_branch=main


get_prompt() {
    if [ $# -ne 1 ]; then
        echo "Error: Function requires exactly 1 argument, got $#" >&2
        exit 1
    fi

    local path="$1"

    if [ ! -f "${path}" ]; then
        echo "Error: Required file '$path' not found" >&2
        exit 1
    fi

    echo "Generate unit test for file ${path}"
}

get_branch() {
    echo "claude-$(uuidgen)"
}


run_claude_code() {
    local path="$1"
    local branch=$(get_branch)
    local prompt=$(get_prompt $path)

    git checkout ${main_branch}
    git pull
    git checkout -b ${branch}

    echo ${path} > log-$(uuidgen).txt
    sleep 5s

    git add .
    git commit -m "Add unit test for file $path"
    git push
}
git config push.autoSetupRemote true


run_claude_code "path/to/file-1.java"
run_claude_code "path/to/file-2.java"

git checkout ${main_branch}
