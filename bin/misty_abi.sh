#!/bin/bash

if [ $# -eq 0 ]; then
	echo "Missing json contract filename"
	echo
	echo "  eg."
	echo "    % misty_abi.sh build/contracts/name.json"
	echo
	exit 1
fi

if [ ! -f $1 ]; then
	echo "File doesn't exist: $1"
	exit 1
fi

cat $1 | python -c "import sys, json; parsed=json.load(sys.stdin)['abi']; pretty=json.dumps(parsed, indent=4); print(pretty)"
