# !/bin/bash

##############################################################################
# Script che esegue una transazione che prevede due firmatari tramite CLI    #
# dove proposer e payer sono il primo firmatario                             #
#                                                                            #
# Parametri:                                                                 #
# $1 -> Percorso alla transazione da buildare                                #
# $2 -> Nome del primo firmatario                                            #
# $3 -> Address del primo firmatario                                         #
# $4 -> Nome del secondo firmatario                                          #
# $5 -> Address del second firmatario                                        #
# $@ > 5 -> Argomenti della transazione                                          #
##############################################################################

count=1
for arg in "$@"
do
    if (($count > 5 ))
    then
        args="$args $arg"
    fi
    count=$(($count + 1))
done


# File temporaneo per salvare i compilati
tmp="./tmp"

# Build della transazione 
flow transactions build $1 $args --proposer $2 --payer $2 \
    --authorizer $5 --authorizer $3  -s $tmp -x payload -y >> /dev/null && \
# $4 firma il payload 
flow transactions sign $tmp --signer $4 -s $tmp -x payload -y >> /dev/null && \
\
# $2 firma payload e envelope
flow transactions sign $tmp --signer $2 -s $tmp -x payload -y >> /dev/null && \
\
# Esegue la transazione
flow transactions send-signed $tmp -x payload -y >> /dev/null && \
\
# Elimina il file temporaneo
rm $tmp >> /dev/null