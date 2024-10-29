#!/bin/sh

#  get the path of this cript
SCRIPT_DIR=$(dirname "$0")
# get absolute path
SCRIPT_DIR=$(cd "$SCRIPT_DIR" && pwd)
echo "$SCRIPT_DIR"

# find the execution name "code-server"
cat $SCRIPT_DIR/extensions/install-list.txt | while read f; do $(find "$SCRIPT_DIR" -name "code-server") --install-extension $f; done

