FROM alpine/git:v2.24.1

LABEL "name"="Git Actions for Github Actions Workflows"
LABEL "maintainer"="Know Ops"
LABEL "version"="0.0.1"

LABEL "com.github.actions.name"="Git Actions for Github Actions Workflows"
LABEL "com.github.actions.derscription"="Simplified Git Tasks for use with Github Actions workflows."
LABEL "com.github.actions.icon"="terminal"
LABEL "com.github.actions.color"="purple"

RUN apk add --no-cache bash

COPY actions/ /opt/know-ops/bin/
COPY entrypoint.sh /opt/know-ops/bin

ENTRYPOINT [ "/opt/know-ops/bin/entrypoint.sh" ]