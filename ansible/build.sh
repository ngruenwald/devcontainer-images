#!/bin/sh

ANSIBLE_VERSION=${1:-9.5.1}     # 2.9.14
IMAGE_NAME=localhost/ansible

buildah bud \
  --tag ${IMAGE_NAME}:${ANSIBLE_VERSION} \
  --build-arg ANSIBLE_VERSION=${ANSIBLE_VERSION} \
  .
