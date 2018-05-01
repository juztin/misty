#!/bin/bash
#
# Usefull?
#   https://github.com/skozin/ethereum-dev-net/blob/master/run-geth.sh
#
# Mist:
#   To connect Mist to this chain
#
#	```
#   % /Applications/Mist.app/Contents/MacOS/Mist --network 10 --rpc ${PWD}/.blockchain/geth.ipc
#   ```
#


MINER_JS=`dirname "$0"`"/../scripts/miner.js"

geth \
	--datadir ./.blockchain \
	--networkid 10 \
	--maxpeers 3 \
	--nat "any" \
	--nodiscover \
	--rpc \
	--rpcaddr 0.0.0.0 \
	--rpcapi "db,eth,net,web3" \
	--rpccorsdomain="*" \
	--ws \
	--wsaddr 0.0.0.0 \
	--metrics \
	--preload "$MINER_JS" \
	console
