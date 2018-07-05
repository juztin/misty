#!/bin/bash
#
# Usefull?
#   https://github.com/skozin/ethereum-dev-net/blob/master/run-geth.sh
#
# Mist:
#   To connect Mist to this chain
#
#	```
#   % /Applications/Mist.app/Contents/MacOS/Mist --network 10 --rpc ${PWD}/.misty/blockchain/geth.ipc
#   ```
#


# We need to get the source directory for the script (resolve symlinked file)
#   (OSX doesn't have `readlink -f`, so here's an ugly hack)
DIR=`dirname $0`
if [ -L $0 ]; then
	# one-liner
	#MINER_JS=$DIR/$(dirname "$(ls -l $DIR/misty_run.sh | awk '{print $11}')")"/../scripts/miner.js"
	#
	# readable'ish
	LINKED_NAME=$(ls -l $DIR/misty_run.sh | awk '{print $11}')  # Get the linked filename
	LINKED_DIR=`dirname  $LINKED_NAME`                          # Get the directory of the linked file
	MINER_JS=$DIR/$LINKED_DIR"/../scripts/miner.js"             # Geth the path to miner.js
else
	MINER_JS=$DIR"/../scripts/miner.js"
fi


geth \
	--datadir ./.misty/blockchain \
	--networkid 10 \
	--maxpeers 3 \
	--nat "any" \
	--nodiscover \
	--rpc \
	--rpcaddr 0.0.0.0 \
	--rpcapi "db,eth,net,web3,personal" \
	--rpccorsdomain="*" \
	--ws \
	--wsaddr 0.0.0.0 \
	--metrics \
	--preload "$MINER_JS" \
	--gcmode archive \
	console
