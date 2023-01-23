# !/bin/bash

flow deploy project

flow transactions send ./Cadence/Transactions/setup_account.cdc --signer Alice
flow transactions send ./Cadence/Transactions/setup_account.cdc --signer Bob