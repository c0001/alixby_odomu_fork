#!/usr/bin/env bash

set -e
_BASH_SRC_FILE="${BASH_SOURCE[0]}"
while [ -h "$_BASH_SRC_FILE" ]; do # resolve $_BASH_SRC_FILE until the file is no longer a symlink
  _BASH_SRC_DIR="$( cd -P "$( dirname "$_BASH_SRC_FILE" )" >/dev/null && pwd )"
  _BASH_SRC_FILE="$(readlink "$_BASH_SRC_FILE")"

  # if $_BASH_SRC_FILE was a relative symlink, we need to resolve it relative
  # to the path where the symlink file was located
  [[ $_BASH_SRC_FILE != /* ]] && _BASH_SRC_FILE="$_BASH_SRC_DIR/$_BASH_SRC_FILE"
done
_BASH_SRC_DIR="$( cd -P "$( dirname "$_BASH_SRC_FILE" )" >/dev/null && pwd )"
_BASH_ORIG_PWD="$(pwd)"
set +e

# * lib

_msg ()
{
  echo -e "[ehome-clash-verge-build] $1"
}

function _date ()
{
  date -u +'%Y%m%d%H%M%S'
}

function _warn ()
{
  _msg "\e[33m[warn: $(_date)] $1\e[0m"
}

function _err ()
{
  _msg "\e[31m[error: $(_date)] $1\e[0m"
  exit 1
}

function _nerr ()
{
  if [ $? -ne 0 ]; then
    _err "$1"
  fi
}

function _job_msg ()
{
  _msg "\e[32m[Job: $(_date)] $1 ...\e[0m"
}

function _job_msg_sub ()
{
  _msg "--> \e[32m[SubJob: $(_date)] $1 ...\e[0m"
}

function _ok_msg ()
{
  _msg "\e[32m[OK: $(_date)] $1\e[0m"
}

# * main

declare use_http_proxy

set -e
[ -n "${_BASH_SRC_DIR}" ] && [ "${_BASH_SRC_DIR}" != '/' ]
cd "${_BASH_SRC_DIR}/"

if [[ -n $http_proxy ]]; then
  use_http_proxy=$http_proxy
elif [[ -n $HTTP_PROXY ]]; then
  use_http_proxy=$HTTP_PROXY
elif [[ -n $https_proxy ]]; then
  use_http_proxy=$https_proxy
elif [[ -n $HTTPS_PROXY ]]; then
  use_http_proxy=$HTTPS_PROXY
fi

if [[ -n $use_http_proxy ]]; then
  yarn config set httpProxy "$use_http_proxy"
fi

yarn install
yarn run build:electron
