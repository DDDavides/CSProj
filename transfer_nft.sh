# !/bin/bash

#
# $1 -> nome di chi possiede l'NFT (chi firma la transazione)
# $2 -> indirizzo di chi vuoi riceva l'NFT
# $3 -> ID dell'nft da inviare
#

nonfungibletoken="./Cadence/Transactions/NonFungibleToken"
flow transactions send $nonfungibletoken/transfer_nft.cdc $2 $3 --signer $1