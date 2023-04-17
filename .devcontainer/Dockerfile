ARG VARIANT="16-bullseye"
FROM mcr.microsoft.com/vscode/devcontainers/typescript-node:${VARIANT}

COPY scripts/message.sh /usr/local/etc/

RUN apt-get update

ARG NODE_MODULES="npm typescript @google/clasp"

RUN su node -c "umask 0002 && npm install -g ${NODE_MODULES}" \
    && npm cache clean --force > /dev/null 2>&1