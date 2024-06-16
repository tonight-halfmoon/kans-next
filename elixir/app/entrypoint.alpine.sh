#!/usr/bin/env sh

set -o errexit

/app/bin/migrate

/app/bin/kans start
