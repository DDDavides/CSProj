# !/bin/bash

marketplace="./Cadence/Transactions/Marketplace"

# crea la vendita per il token 0 per 10 flowtoken
flow transactions send ${marketplace}/create_sale.cdc 0 10.0

# effettua l'acquisto da parte di Alice del token 0 
flow transactions send ${marketplace}/purchase_nft.cdc 0 f8d6e0586b0a20c7 --signer Alice
