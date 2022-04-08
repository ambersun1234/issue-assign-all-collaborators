FROM alpine:latest

# installes required packages for our script
RUN apk add --no-cache \
    bash \
    jq \
    curl

# Copies your code file  repository to the filesystem
COPY issue-assign-all-collaborators.sh /issue-assign-all-collaborators.sh

# change permission to execute the script and
RUN chmod +x /issue-assign-all-collaborators.sh

# file to execute when the docker container starts up
ENTRYPOINT ["/issue-assign-all-collaborators.sh"]