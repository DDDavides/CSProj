# CSProj
Progetto del corso magistrale di Cybersecurity

# Prerequisiti
Prerequisiti per far funzionare il sistema
* Sistema Unixn (per i cmandi shell)
* Flow CLI

# Esecuzione
1. start.sh (bloccante)
2. Aprire una nuova finestra del terminale
3. Aprire una nuova finestra e lavorare con flow CLI:
    2.a (se non è deployato) flow project deploy
    2.b flow transactions send setup_account --signer <nome account>
    <!-- flow transactions send setup_account_to_receive_royalty /public/GenericFTReceiver -->
    2.c flow transactions send setup_account (per farlo sull emulatore)
    2.d flow transactions send mint_nft <chi avrà NFT mintato> <nome NFT> <metadata>
    2.e flow transactions send transfer_nft (--signer <nome di chi vuole trasferire se diverso dall account corrente>) <a chi va> <idNFT da trasferire> 