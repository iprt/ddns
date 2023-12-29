#!/bin/bash
# shellcheck disable=SC2164
SHELL_FOLDER=$(
  cd "$(dirname "$0")"
  pwd
)
cd "$SHELL_FOLDER"

RR=$1
DOMAIN=$2

function DescribeSubDomainRecords() {
  # shellcheck disable=SC2086
  aliyun alidns DescribeSubDomainRecords --SubDomain $RR.$DOMAIN
}

DescribeSubDomainRecords
