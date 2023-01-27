# !bin/bash

##############################################################################
# Script che minta un NFT con i parametri passati                            #
#                                                                            #
# Parametri:                                                                 #
# $1 -> Indirizzo di chi minta e ottiene l'NFT                               #
# $2 -> Nome del NFT                                                         #
# $3 -> Descrizione del NFT                                                  #
# $4 -> Thumbnail del NFT                                                    #
# $5 -> Healt del NFT                                                        #
# $6 -> Attack del NFT                                                       #
# $7 -> Defence del NFT                                                      #
# $8 -> cuts del NFT                                                         #
# $9 -> royaltyDescription del NFT                                           #
##############################################################################

path="./Cadence/Transactions/NonFungibleToken/mint_nft.cdc"

echo "Minting NFT..."

flow transactions send $path $1 $2 $3 $4 $5 $6 $7 $8 $9
# e.g. flow transactions send ./Cadence/Transactions/mint_nft.cdc nome desc thumb 100.0 20.3 30.4 '[1.1]' '["royaltyDesc"]'