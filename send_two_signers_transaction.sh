# !/bin/bash

##############################################################################
# Script che esegue una transazione che prevede due firmatari tramite CLI    #
# dove proposer e payer sono il primo firmatario                             #
#                                                                            #
# Parametri:                                                                 #
# $1 -> Percorso alla transazione da buildare                                #
# $2 -> Address del primo firmatario                                         #
# $3 -> Nome del primo firmatario                                            #
# $4 -> Address del second firmatario                                        #
# $5 -> Nome del secondo firmatario                                          #
##############################################################################

# File temporaneo per salvare i compilati
tmp="./tmp"

# Build della transazione 
flow transactions build $1 --proposer $2 --payer $2 \
    --authorizer $5 --authorizer $3  -s $tmp -x payload -y >> /dev/null

# $4 firma il payload 
flow transactions sign $tmp --signer $4 -s $tmp -x payload -y >> /dev/null

# $2 firma payload e envelope
flow transactions sign $tmp --signer $2 -s $tmp -x payload -y >> /dev/null

# Esegue la transazione
flow transactions send-signed $tmp -x payload -y >> /dev/null

# Elimina il file temporaneo
rm $tmp >> /dev/null