import NonFungibleToken from "../Contracts/NonFungibleToken.cdc"
import ExampleNFT from "../Contracts/ExampleNFT.cdc"

/// This transaction is what an account would run
/// to unlink its collection from public storage

transaction {

    prepare(signer: AuthAccount) {

        if signer.getCapability(ExampleNFT.CollectionPublicPath).check<&{ExampleNFT.ExampleNFTCollectionPublic}>() {
            log("Unlinking ExampleNFTCollectionPublic from PublicPath")
            signer.unlink(ExampleNFT.CollectionPublicPath)
        }

    }
}
