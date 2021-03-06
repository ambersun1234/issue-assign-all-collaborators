#!/bin/bash

set -e

RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
NC='\033[0m'

status_ok='200'
status_created='201'

OWNER=${INPUT_OWNER}
REPO=${INPUT_REPOSITORY}
ISSUE_NUM=${INPUT_ISSUE_NUM}
API_URL=${INPUT_API_URL}
TOKEN=${INPUT_TOKEN}
REPO_NAME=

preprocess() {
    REPO_NAME=$(echo ${REPO} | cut -d '/' -f 2)
}

get_repo_collaborators() {
    # https://docs.github.com/en/rest/reference/collaborators#list-repository-collaborators
    collaborators_response=$(
        curl -w "%{http_code}" -sH "Authorization: token ${TOKEN}" \
        ${API_URL}/repos/${OWNER}/${REPO_NAME}/collaborators
    )
    IFS=' '
    status_code=$(echo ${collaborators_response} | tail -n 1)
    collaborators_response=$(echo ${collaborators_response} | head -n -1)
    IFS=$' \t\n'

    if [ ${status_code} == "${status_ok}" ]; then
        echo -e "${GREEN}Successfully get '${REPO}' repository collaborators${NC}" >&2
    else
        echo -e "${RED}ERROR: Failed to get '${REPO}' repository collaborators${NC}" >&2
        echo ${collaborators_response} >&2
        exit 1
    fi
    echo $(echo ${collaborators_response} | jq '.[] | .login')
}

assign_repo_issue() {
    # https://docs.github.com/en/rest/reference/issues#add-assignees-to-an-issue
    arr=($1)
    printf -v username_list '%s,' "${arr[@]}"
    username_list=$(echo ${username_list%,})

    assign_issue_response=$(
        curl -w "%{http_code}" -sH "Authorization: token ${TOKEN}" \
        -d "{\"assignees\":[${username_list}]}" \
        ${API_URL}/repos/${OWNER}/${REPO_NAME}/issues/${ISSUE_NUM}/assignees
    )
    IFS=' '
    status_code=$(echo ${assign_issue_response} | tail -n 1)
    IFS=$' \t\n'

    if [ ${status_code} == "${status_created}" ]; then
        echo -e "${GREEN}Successfully assign ${username_list} to issue #${ISSUE_NUM} assignee${NC}"  >&2
    else
        echo -e "${RED}ERROR: Failed to assign ${username_list} to issue #${ISSUE_NUM} assignee${NC}" >&2
        echo ${assign_issue_response} >&2
        exit 1
    fi
}

preprocess
collaborators_list=$(get_repo_collaborators)
assign_repo_issue "${collaborators_list[@]}"