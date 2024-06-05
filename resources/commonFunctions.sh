#!/bin/bash

function echo_notification() {
  echo -e '\033[0;34m'$1'\033[0m'
}

function echo_error() {
  echo -e '\033[0;31m'$1'\033[0m'
}

function echo_warning() {
  echo -e '\033[0;33m'$1'\033[0m'
}

function echo_ok() {
  echo -e '\033[0;32m'$1'\033[0m'
}

function echo_value_if_exists() {
  if [ -f "$1" ]; then
    echo " -f $1"
  fi
}

function changelog_generator() {
  # playing with IFS can be tricky because it's an internal variable used by many things in bash and it also needs to be unset
  # protect this script by executing the following in a subshell
  (
    IFS=$'\n'
    for line in $(git log --date=short --pretty=format:"%s" --decorate "${1}".."${2}"); do
      echo "- ${line}" >> changelog.txt
    done
  )
}


set -e

function aws_auth() {
  aws sts assume-role --role-arn $1 --role-session-name jenkins > credentials.temp
  set +x
  # as per https://github.com/koalaman/shellcheck/wiki/SC2155
  AWS_ACCESS_KEY_ID=$(more credentials.temp | grep -o '"AccessKeyId": ".*"'|sed 's/"//g'|cut -d " " -f2-)
  export AWS_ACCESS_KEY_ID
  AWS_SECRET_ACCESS_KEY=$(more credentials.temp | grep -o '"SecretAccessKey": ".*"'|sed 's/"//g'|cut -d " " -f2-)
  export AWS_SECRET_ACCESS_KEY
  AWS_SESSION_TOKEN=$(more credentials.temp | grep -o '"SessionToken": ".*"'|sed 's/"//g'|cut -d " " -f2-)
  export AWS_SESSION_TOKEN
  rm -rf credentials.temp
}
