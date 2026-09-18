#!/bin/sh
set -e

# Installs to $HOME/go/bin, already on PATH via system/exports.symlink
/usr/local/go/bin/go install github.com/google/osv-scanner/v2/cmd/osv-scanner@latest
