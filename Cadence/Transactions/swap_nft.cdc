import DDDNFT from "../Contracts/DDDNFT.cdc"
transaction(toSwapNFTid1: UInt64, toSwapNFTid2: UInt64){

    /// Reference to the withdrawer's collection
    let swapRef1: &DDDNFT.Collection
    let swapRef2: &DDDNFT.Collection

    prepare(signer1: AuthAccount, signer2: AuthAccount){
        // borrow a reference to the signer's NFT collection
        self.swapRef1 = signer1
            .borrow<&DDDNFT.Collection>(from: DDDNFT.CollectionStoragePath)
            ?? panic("Account does not store an object at the specified path")
        
        self.swapRef2 = signer2
            .borrow<&DDDNFT.Collection>(from: DDDNFT.CollectionStoragePath)
            ?? panic("Account does not store an object at the specified path")
    }

    pre{
        self.swapRef1.getIDs().contains(toSwapNFTid1): "Original owner(1) should have the NFT(1) before swapping it"
        self.swapRef2.getIDs().contains(toSwapNFTid2): "Original owner(2) should have the NFT(2) before swapping it"
    }

    execute{
        let nft1 <- self.swapRef1.withdraw(withdrawID: toSwapNFTid1)
        let nft2 <- self.swapRef2.withdraw(withdrawID: toSwapNFTid2)

        self.swapRef1.deposit(token: <-nft2)
        self.swapRef2.deposit(token: <-nft1)
    }

    post{
        !self.swapRef1.getIDs().contains(toSwapNFTid1): "Original owner(1) should not have the swapped NFT(1) anymore"
        !self.swapRef2.getIDs().contains(toSwapNFTid2): "Original owner(2) should not have the swapped NFT(2) anymore"
        self.swapRef1.getIDs().contains(toSwapNFTid2): "The reciever(1) should now own the NFT(2)"
        self.swapRef2.getIDs().contains(toSwapNFTid1): "The reciever(2) should now own the NFT(1)"
    }
}