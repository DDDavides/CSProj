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

usage="$(basename "$0") [-h] -- program to execute swapping transaction passing 9 required arguments

required arguments:
1 -> Indirizzo di chi minta e ottiene l'NFT
2 -> Nome del NFT
3 -> Descrizione del NFT
4 -> Thumbnail del NFT
5 -> Healt del NFT
6 -> Attack del NFT
7 -> Defence del NFT
8 -> cuts del NFT
9 -> royaltyDescription del NFT"

while getopts ':hs:' option; do
  case "$option" in
    h) echo "$usage"
       exit
       ;;
   \?) printf "illegal option\n">&2
       echo "$usage" >&2
       exit 1
       ;;
  esac
done
shift $((OPTIND - 1))

path="./Cadence/Transactions/mint_nft.cdc"

echo "Minting NFT..."

flow transactions send $path $1 $2 $3 $4 $5 $6 $7 $8 $9
# e.g. flow transactions send ./Cadence/Transactions/mint_nft.cdc nome desc thumb 100.0 20.3 30.4 '[1.1]' '["royaltyDesc"]'
