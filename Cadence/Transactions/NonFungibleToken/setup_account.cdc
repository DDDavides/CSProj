import NonFungibleToken from "../../Contracts/NonFungibleToken.cdc"
import DDDNFT from "../../Contracts/DDDNFT.cdc"
import MetadataViews from "../../Contracts/MetadataViews.cdc"

/// This transaction is what an account would run
/// to set itself up to receive NFTs

transaction {

    prepare(signer: AuthAccount) {
        // Return early if the account already has a collection
        if signer.borrow<&DDDNFT.Collection>(from: DDDNFT.CollectionStoragePath) != nil {
            return
        }

        // Create a new empty collection
        let collection <- DDDNFT.createEmptyCollection()

        // save it to the account
        signer.save(<-collection, to: DDDNFT.CollectionStoragePath)

        // create a public capability for the collection
        signer.link<&{NonFungibleToken.CollectionPublic, DDDNFT.DDDNFTCollectionPublic, MetadataViews.ResolverCollection}>(
            DDDNFT.CollectionPublicPath,
            target: DDDNFT.CollectionStoragePath
        )
    }
}
 