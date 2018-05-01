#!/bin/bash
#
# Mac OS script to launch Mist and connect to the Geth node.
#


/Applications/Mist.app/Contents/MacOS/Mist \
	--network 10 \
	--rpc ./.misty/blockchain/geth.ipc
