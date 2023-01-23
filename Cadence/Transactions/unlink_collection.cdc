import NonFungibleToken from "../Contracts/NonFungibleToken.cdc"
import DDDNFT from "../Contracts/DDDNFT.cdc"

/// This transaction is what an account would run
/// to unlink its collection from public storage

transaction {

    prepare(signer: AuthAccount) {

        if signer.getCapability(DDDNFT.CollectionPublicPath).check<&{DDDNFT.DDDNFTCollectionPublic}>() {
            log("Unlinking DDDNFTCollectionPublic from PublicPath")
            signer.unlink(DDDNFT.CollectionPublicPath)
        }

    }
}
