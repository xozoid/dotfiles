#!/bin/sh
set -e

sudo apt install -y asciidoctor
mkdir -p ~/.local/bin
curl -sL https://github.com/errata-ai/vale/releases/download/v3.15.2/vale_3.15.2_Linux_64-bit.tar.gz | tar -xz -C ~/.local/bin vale
