# !/bin/bash

transactions="./Cadence/Transactions"
scripts="./Cadence/Scripts"


## deploy dei contratti del progetto
echo "Deploy dei contratti del progetto.."
flow deploy project


## Setup degli account
echo "Setup degli account di test.."
flow transactions send ${transactions}/setup_account.cdc --signer Alice
flow transactions send ${transactions}/setup_account.cdc --signer Bob
flow transactions send ${transactions}/setup_account.cdc


## Mint di un NFT da parte dell'emulatore
echo "\bMinting di un NFT a carico dell'emulatore.."
flow transactions send ${transactions}/mint_nft.cdc \
    f8d6e0586b0a20c7 Defender descrizione thumbnail 100.0 4.9 18.0 '[1.0]' '["nulla"]'

flow transactions send ${transactions}/mint_nft.cdc \
    f8d6e0586b0a20c7 Attacker descrizione thumbnail 20.0 10.5 7.0 '[1.0]' '["nulla"]'


## Per vedere i metadati di un NFT dell'account dell'emulatore
# id_nft=0
# flow scripts execute ${scripts}/get_nft_metadata.cdc 0xf8d6e0586b0a20c7 $id_nft