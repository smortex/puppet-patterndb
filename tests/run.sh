#!/bin/sh

[[ ! -d "./tests" ]] && { echo "No tests to run"; exit 0; }

find ./tests -type f -name '*.pp' -exec puppet apply --noop --verbose {} \;
