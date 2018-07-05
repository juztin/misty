#!/bin/bash
#
# Initializes a new Get blockchain with {n} number of accounts, each with 999 Ethereum.
#

PASSWORD="password"                # The password to use within the password file.
PASSWORD_FILE=".misty/password"    # Password file used for new accounts.
ACCOUNT_NUM=10                     # Number of accounts to create.
BLOCK_DIFFICULTY="0x400"           # Mining difficulty.
BLOCK_GASLIMIT="0x8000000"         # Gas limit.

set -e

# ------------------------------------------------------------------------------

ACCOUNT_ID=""
ACCOUNTS_JSON=""

# Creates an account, and sets the id to `accountId`.
#
# @param 1: password for the account
createAccount() {
	#  Receives:
	#    ```
	#    Address: {1f057006cb657678b6ae849b954154c00b4a1f0c}
	#    ```
	#  Sets:
	#    accountId="1f057006cb657678b6ae849b954154c00b4a1f0c"
	#
	data=`geth --datadir .misty/blockchain account new --password "$1"`
	ACCOUNT_ID=`echo $data | awk -F"{|}" '{print $2}'`
}

# Creates {n} number of accounts.
#
# @param 1: Number of accounts to create.
# @param 2: The password to use for the accounts. (TODO: allow passing an array for unique passwords?)
createAccounts() {
	# @param 1
	password_file="$2"
	password=`cat $2`
	ACCOUNTS_JSON="[\n"
	# Creates `n` number of accounts
	for (( i=0; i<$1; i++)); do
		createAccount "$password_file"
		privateKey=`gethpkey --key=$ACCOUNT_ID --password=$password`
		ACCOUNTS_JSON="${ACCOUNTS_JSON}\t{\n\t\tkey: ${ACCOUNT_ID},\n\t\tprivateKey: \"${privateKey}\",\n\t\tpassword: \"${password}\"\n\t},\n"
		ACCOUNTS=$ACCOUNTS'"0x'$ACCOUNT_ID'": { "balance": "999000000000000000000" },'$'\n    '
	done
	# Remove trailing comma
	ACCOUNTS=${ACCOUNTS:0:${#ACCOUNTS}-6}
	ACCOUNTS_JSON=${ACCOUNTS_JSON:0:${#ACCOUNTS_JSON}-3}
	ACCOUNTS_JSON="${ACCOUNTS_JSON}\n]\n"
}

# Creates the genesis Geth configuration file.
#
# @param 1: The name of the genesis file.
createGenesis() {
	echo '{
  "config": {
        "chainId": 10,
        "homesteadBlock": 0,
        "eip150Block": 0,
        "eip150Hash": "0x0000000000000000000000000000000000000000000000000000000000000000",
        "eip155Block": 0,
        "eip158Block": 0,
        "ByzantiumBlock": 0,
        "ethash": {}
    },
  "coinbase"   : "0x0000000000000000000000000000000000000000",
  "difficulty" : '\"$BLOCK_DIFFICULTY\"',
  "gasLimit"   : '\"$BLOCK_GASLIMIT\"',
  "extraData"  : "",
  "mixhash"    : "0x0000000000000000000000000000000000000000000000000000000000000000",
  "nonce"      : "0x0000000000000042",
  "parentHash" : "0x0000000000000000000000000000000000000000000000000000000000000000",
  "timestamp"  : "0x00",
  "alloc": {
    '"$ACCOUNTS"'
  }
}' > ./.misty/genesis.json
}

# Initializes the new Geth blockchain, using the previsously created genesis file.
#
# @param 1: The blockchain directory.
# @param 2: The genesis file.
initNode() {
	geth \
		--datadir .misty/blockchain \
		init .misty/genesis.json
}


# ------------------------------------------------------------------------------

# ----- Create .misty
mkdir ./.misty

# ----- Create Password File
echo "Creating password file: \"$PASSWORD_FILE\""
echo "$PASSWORD" > "$PASSWORD_FILE"

# ----- Create Accounts
echo "Creating $ACCOUNT_NUM Accounts..."
createAccounts $ACCOUNT_NUM "$PASSWORD_FILE";
echo "------------------------------------"
echo "    $ACCOUNTS"
echo "------------------------------------"
printf "$ACCOUNTS_JSON" > .misty/accounts.json

# ----- Create Genesis File
echo "Creating Genesis..."
createGenesis

# ----- Initialize Node
echo "Initializing Node..."
initNode
