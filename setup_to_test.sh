# !/bin/bash

nonfungibletoken="./Cadence/Transactions/NonFungibleToken"
marketplace="./Cadence/Transactions/Marketplace"
fungibletoken="./Cadence/Transactions/FungibleToken"
scripts="./Cadence/Scripts"

## deploy dei contratti del progetto
echo "Deploy dei contratti del progetto.."
flow deploy project


## Setup degli account
echo "Setup degli account di test.."
flow transactions send ${nonfungibletoken}/setup_account.cdc --signer Alice && \
flow transactions send ${nonfungibletoken}/setup_account.cdc --signer Bob && \
flow transactions send ${nonfungibletoken}/setup_account.cdc && \
\
flow transactions send ${fungibletoken}/setup_account.cdc --signer Alice && \
flow transactions send ${fungibletoken}/setup_account.cdc && \
\
flow transactions send ${marketplace}/setup_account.cdc && \
\
## Mint di un NFT da parte dell'emulatore
echo "\bMinting di un NFT a carico dell'emulatore.." && \
flow transactions send ${nonfungibletoken}/mint_nft.cdc \
    f8d6e0586b0a20c7 Attacker descrizione thumbnail 20.0 10.5 7.0 '[1.0]' '["nulla"]' && \
flow transactions send ${nonfungibletoken}/mint_nft.cdc \
    f8d6e0586b0a20c7 Defender descrizione thumbnail 100.0 4.9 18.0 '[1.0]' '["nulla"]' && \
\
flow transactions send ${fungibletoken}/transfer_tokens.cdc \
    100.0 01cf0e2f2f715450 && \
flow transactions send ${fungibletoken}/transfer_tokens.cdc \
    100.0 179b6b1cb6755e31 && \
\
flow transactions send ${nonfungibletoken}/transfer_nft.cdc 01cf0e2f2f715450 0 --signer emuletor-account && \
flow transactions send ${nonfungibletoken}/transfer_nft.cdc 179b6b1cb6755e31 1 --signer emuletor-account && \


## Per vedere i metadati di un NFT dell'account dell'emulatore
# id_nft=0
# flow scripts execute ${scripts}/get_nft_metadata.cdc 0xf8d6e0586b0a20c7 $id_nft
 