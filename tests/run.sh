#!/bin/sh -eu

[ ! -d "./tests" ] && { echo "No tests to run"; exit 0; }

for manifest in $(find ./tests -type f -name '*.pp'); do
	echo '*'
	echo '* Testing manifest `'$manifest'`'
	echo '*'
 	puppet apply $manifest
	echo '*'
	echo '* OK *'
done
