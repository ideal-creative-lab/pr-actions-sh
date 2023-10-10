#!/bin/bash

# Set your OpenAI Key and GitHub User Token here
OPENAI_KEY="sk-your-key-here"
GITHUB_USER_TOKEN="ghp_your_key_here"

# Help menu
function show_help {
    echo "Usage: $0 <pr_url> <command>"
    echo "Commands:"
    echo "  review"
    echo "  describe"
    echo "  improve"
    echo '  ask "Write me a poem about this PR"'
    echo "  reflect"
    echo "  update_changelog"
}

# Check if OpenAI Key and GitHub User Token are set
if [[ -z "$OPENAI_KEY" || -z "$GITHUB_USER_TOKEN" ]]; then
    echo "Please set your OpenAI Key and GitHub User Token in the script."
    exit 1
fi

# Check if all required parameters are provided
if [[ $# -lt 2 ]]; then
    show_help
    exit 1
fi

pr_url=$1
command=$2

# Check if the command is "ask" and set the question
if [[ "$command" == "ask" ]]; then
    question=$3
    if [[ -z "$question" ]]; then
        echo "Please provide a question for the 'ask' command."
        exit 1
    fi
    docker run --rm -it -e OPENAI.KEY="$OPENAI_KEY" -e GITHUB.USER_TOKEN="$GITHUB_USER_TOKEN" codiumai/pr-agent --pr_url "$pr_url" "$command" "$question"
else
    docker run --rm -it -e OPENAI.KEY="$OPENAI_KEY" -e GITHUB.USER_TOKEN="$GITHUB_USER_TOKEN" codiumai/pr-agent --pr_url "$pr_url" "$command"
fi
