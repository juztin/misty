#!/bin/bash
#
# Mac OS script to launch Mist and connect to the Geth node.
#


GETH_IPC=`dirname "$0"`"/../.blockhain/geth.ipc"

/Applications/Mist.app/Contents/MacOS/Mist \
	--network 10 \
	--rpc "$GETH_IPC"
