import FlowToken from "../../Contracts/Utility/FlowToken.cdc"
import FungibleToken from "../../Contracts/Utility/FungibleToken.cdc"
import DDDNFT from "../../Contracts/DDDNFT.cdc"
import NonFungibleToken from "../../Contracts/NonFungibleToken.cdc"
import DDDMarketplace from "../../Contracts/DDDMarketplace.cdc"

pub fun getOrCreateCollectionCapability(account: AuthAccount):  &DDDNFT.Collection{NonFungibleToken.Receiver} {
    if let collectionRef = account.borrow<&DDDNFT.Collection>(from: DDDNFT.CollectionStoragePath) {
        return collectionRef
    }

    // create a new empty collection
    let collection <- DDDNFT.createEmptyCollection() as! @DDDNFT.Collection

    let collectionRef = &collection as &DDDNFT.Collection
    
    // save it to the account
    account.save(<-collection, to: DDDNFT.CollectionStoragePath)

    // create a public capability for the collection
    account.link<&DDDNFT.Collection{NonFungibleToken.CollectionPublic, DDDNFT.DDDNFTCollectionPublic}>(DDDNFT.CollectionPublicPath, target: DDDNFT.CollectionStoragePath)

    return collectionRef
}

transaction(tokenID: UInt64, saleCollectionAddress: Address) {

    let collectionCapability: &DDDNFT.Collection{NonFungibleToken.Receiver}
    let saleCollection: &DDDMarketplace.SaleCollection{DDDMarketplace.SalePublic}
    let temporaryVault: @FungibleToken.Vault

    prepare(acct: AuthAccount){
        self.collectionCapability = getOrCreateCollectionCapability(account: acct)

        self.saleCollection = getAccount(saleCollectionAddress)
                            .getCapability<&DDDMarketplace.SaleCollection{DDDMarketplace.SalePublic}>
                            (DDDMarketplace.SaleCollectionPublicPath).borrow()
                            ?? panic("Could not borrow SaleCollection from provided address")

        let price = self.saleCollection.idPrice(tokenID: tokenID)
                    ?? panic("No token found with that tokeID")

        let vaultref = acct.borrow<&FlowToken.Vault>(from: FlowToken.VaultStoragePath)
            ?? panic("Couldn't borrow owner's vault")
        self.temporaryVault <- vaultref.withdraw(amount: price)
    }

    execute {
        self.collectionCapability.deposit(token: <- self.saleCollection.purchase(tokenID: tokenID, buyTokens: <-self.temporaryVault))
    }

}