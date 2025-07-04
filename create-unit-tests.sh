#!/bin/bash


get_prompt() {
    local path="$1"
    echo "Generate unit test for file ${path}"
}

get_branch() {
    local path="$1"
    echo "cl-$(uuidgen)"
}


run_claude_code() {
    local path="$1"
    local branch=$(get_branch)
    echo $branch
    local prompt=$(get_prompt $path)
    echo $prompt

    git checkout main
    git pull
    git checkout -b $branch

    echo $path > log.txt
    sleep 5s

    git add .
    git commit -m "Add unit test for file $path"
    git push
}
git config push.autoSetupRemote true

run_claude_code "path/to/file-1.java"
run_claude_code "path/to/file-2.java"
