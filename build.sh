#!/usr/bin/env bash
set -o errexit

python3.10 -m venv venv
. venv/bin/activate

python -m pip install -U pip setuptools zc.buildout

buildout bootstrap
buildout
