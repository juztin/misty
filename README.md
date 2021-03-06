# Misty

Collection of helper scripts that facilitate getting a private Geth node, with 10 prefunded accounts, up and running, as well as
linking Mist up with the private node.

### Prerequisites

 - Bash
 - Geth 1.8
 - Truffle 4.1
 - [gethpkey](https://github.com/juztin/gethpkey) _(optional for use with `misty_init_keys.sh`)_

The only requirements to use the helper scripts are having `Geth` and `Mist` installed, and a `Bash` shell.

### Setup

 1. Clone this repo
 2. Add this repos `./bin` to your path


### Startup

The following steps will:  
_(these all need to be run from the same path)_

 1. Initialize the Node

     ```bash
     % misty_init.sh
     ```

     or

     ```bash
     % misty_init_keys.sh
     ```
     _(this script uses `gethpkey` to output the public/private keys and password into `./.misty/accounts.json`)_

 2. Start the Auto-Miner, and drop into a Geth console

    ```bash
    % misty_run.sh
    ```

 3. Start Mist _(in another shell)_

    ```bash
    % misty.sh
    ```

    _*This script assumes you're on OSX, if not, just execute Mist like:_

    ```bash
    /path/to/mist/executable \
    	--network 10 \
    	--rpc `dirname "$0"`"/../.blockhain/geth.ipc"
    ```

### Truffle

To setup Truffle to deploy contracts to the above Geth nodes:

 1. Add the Geth node to `truffle.js` _(use your `ip` for the `host`, and one of the accounts created above for the `from`)_

    ```javascript
    module.exports = {
      networks: {

        mist: {
          host: '192.168.1.199',
          port: 8545,
          network_id: '*', // eslint-disable-line camelcase
          from: '0x4b68328d09470cb954bd1f437af302de09bcbfa1'  // An account listed within `genesis.json`
        }

      }
    };
    ```

 2. Unlock the account listed within `truffle.js`

     ```javascript
     // Unlocks the given account, with the corresponding password, for 15 seconds.
     web3.personal.unlockAccount("0x4b68328d09470cb954bd1f437af302de09bcbfa1", "password", 15000)
     ```
     or
     ```javascript
     // Unlocks all accounts, with the corresponding password, for 15 seconds.
     web3.personal.listAccounts.forEach(function (account) { web3.personal.unlockAccount(account, "password", 0) });
     ```

 3. Deploy your contract(s)

    ```shell
    % truffle migrate --network mist --reset
    ```


#### Add the deployed contract to the running instance of Mist

 1. Click `Contracts` from the main Mist screen, and then `Watch Contract`, towards the bottom of the screen.
 2. In the dialog:  
   1. Enter the contract address from the above Truffle migrate command
   2. Enter the contract name _(this can be anything you want)_
   3. Add the JSON Interface by copying the output from below into the `JSON INTERFACE` field:  

      ```bash
      misty_abi.sh build/contracts/{contract_name}.json
      ```

From here you should see your contract, and be able to call all the functions.

### Reset

To reset your node, simply run the `misty_reset.sh` script and re-run the [Startup](#startup) process.
