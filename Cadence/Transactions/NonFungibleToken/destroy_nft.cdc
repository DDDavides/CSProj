import NonFungibleToken from "../../Contracts/NonFungibleToken.cdc"
import DDDNFT from "../../Contracts/DDDNFT.cdc"

/// This transaction withdraws an NFT from the signers collection and destroys it

transaction(id: UInt64) {

    /// Reference that will be used for the owner's collection
    let collectionRef: &DDDNFT.Collection

    prepare(signer: AuthAccount) {

        // borrow a reference to the owner's collection
        self.collectionRef = signer.borrow<&DDDNFT.Collection>(from: DDDNFT.CollectionStoragePath)
            ?? panic("Account does not store an object at the specified path")

    }

    execute {

        // withdraw the NFT from the owner's collection
        let nft <- self.collectionRef.withdraw(withdrawID: id)

        destroy nft
    }

    post {
        !self.collectionRef.getIDs().contains(id): "The NFT with the specified ID should have been deleted"
    }
}
