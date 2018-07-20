FROM ubuntu:latest

ENV VAULT_VERSION 0.10.3

RUN apt-get update && \
    apt-get install --yes jq wget unzip

RUN wget -qO /tmp/vault.zip https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip && \
      unzip -d /bin /tmp/vault.zip && \
      chmod +x /bin/vault && \
      rm /tmp/vault.zip

ADD assets/ /opt/resource/
