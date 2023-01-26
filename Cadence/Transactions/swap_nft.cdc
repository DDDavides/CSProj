import DDDNFT from "../Contracts/DDDNFT.cdc"

/// This transaction allows swapping NFTs between two accounts.
///
/// N.B. Arguments' order, either in transaction and prepare statement, is relevant, 
/// because the first id is associated to the NFT whose owner is the first AuthAccount passed in prepare.

transaction(toSwapNFTid1: UInt64, toSwapNFTid2: UInt64){

    /// Reference to the accounts' collection
    let swapRef1: &DDDNFT.Collection
    let swapRef2: &DDDNFT.Collection

    prepare(signer1: AuthAccount, signer2: AuthAccount){
        // borrow a reference to the signers' NFT collection where NFTS to swap are stored
        self.swapRef1 = signer1
            .borrow<&DDDNFT.Collection>(from: DDDNFT.CollectionStoragePath)
            ?? panic("Account does not store an object at the specified path")
        self.swapRef2 = signer2
            .borrow<&DDDNFT.Collection>(from: DDDNFT.CollectionStoragePath)
            ?? panic("Account does not store an object at the specified path")
    }

    //Check if the first(second) NFT (i.e. whose id is the first(second) argument of this tx) 
    //is owned by first(second) signer
    pre{
        self.swapRef1.getIDs().contains(toSwapNFTid1): "Original owner(1) should have the NFT(1) before swapping it"
        self.swapRef2.getIDs().contains(toSwapNFTid2): "Original owner(2) should have the NFT(2) before swapping it"
    }

    execute{
        //Withdraw NFTs from their owners' collections
        let nft1 <- self.swapRef1.withdraw(withdrawID: toSwapNFTid1)
        let nft2 <- self.swapRef2.withdraw(withdrawID: toSwapNFTid2)

        //Swap NFT
        self.swapRef1.deposit(token: <-nft2)
        self.swapRef2.deposit(token: <-nft1)
    }

    //Check if swapping is correctly done
    post{
        !self.swapRef1.getIDs().contains(toSwapNFTid1): "Original owner(1) should not have the swapped NFT(1) anymore"
        !self.swapRef2.getIDs().contains(toSwapNFTid2): "Original owner(2) should not have the swapped NFT(2) anymore"
        self.swapRef1.getIDs().contains(toSwapNFTid2): "The reciever(1) should now own the NFT(2)"
        self.swapRef2.getIDs().contains(toSwapNFTid1): "The reciever(2) should now own the NFT(1)"
    }
}