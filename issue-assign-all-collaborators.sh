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
REF=${INPUT_REF}
API_URL=${INPUT_API_URL}
TOKEN=${INPUT_TOKEN}
REPO_NAME=
ISSUE_NUM=

preprocess() {
    REPO_NAME=$(echo ${REPO} | cut -d '/' -f 2)
    ISSUE_NUM=$(echo ${REF} | cut -d '/' -f 3)
}

get_repo_collaborators() {
    # https://docs.github.com/en/rest/reference/collaborators#list-repository-collaborators
    collaborators_response=$(
        curl -w "%{http_code}" -sH "Authorization: token ${TOKEN}" \
        ${API_URL}repos/${OWNER}/${REPO_NAME}/collaborators
    )
    IFS=' '
    status_code=$(echo ${collaborators_response} | tail -n 1)
    collaborators_response=$(echo ${collaborators_response} | head -n -1)
    IFS=$' \t\n'

    if [ ${status_code} == "${status_ok}" ]; then
        echo -e "${GREEN}Successfully get '${OWNER}/${REPO}' repository collaborators${NC}" > /dev/tty
    else
        echo -e "${RED}ERROR: Failed to get '${OWNER}/${REPO}' repository collaborators${NC}" > /dev/tty
        echo ${collaborators_response} > /dev/tty
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
        ${API_URL}repos/${OWNER}/${REPO_NAME}/issues/${ISSUE_NUM}/assignees
    )
    IFS=' '
    status_code=$(echo ${assign_issue_response} | tail -n 1)
    IFS=$' \t\n'

    if [ ${status_code} == "${status_created}" ]; then
        echo -e "${GREEN}Successfully assign ${username_list} to issue #${ISSUE_NUM} assignee${NC}"  > /dev/tty
    else
        echo -e "${RED}ERROR: Failed to assign ${username_list} to issue #${ISSUE_NUM} assignee${NC}" > /dev/tty
        echo ${assign_issue_response} > /dev/tty
        exit 1
    fi
}

mknod -m 644 /dev/tty c 5 0
chmod o+rw /dev/tty

preprocess
collaborators_list=$(get_repo_collaborators)
assign_repo_issue "${collaborators_list[@]}"