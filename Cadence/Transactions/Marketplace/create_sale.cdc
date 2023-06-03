import FlowToken from "../../Contracts/Utility/FlowToken.cdc"
import FungibleToken from "../../Contracts/Utility/FungibleToken.cdc"
import DDDNFT from "../../Contracts/DDDNFT.cdc"
import NonFungibleToken from "../../Contracts/NonFungibleToken.cdc"
import DDDMarketplace from "../../Contracts/DDDMarketplace.cdc"

pub fun getOrCreateSaleCollection(account: AuthAccount, ownerCollection: Capability<&{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>, ownerVault: Capability<&AnyResource{FungibleToken.Receiver}>): &DDDMarketplace.SaleCollection{
    if let saleCollRef = account.borrow<&DDDMarketplace.SaleCollection>(from: DDDMarketplace.SaleCollectionStoragePath) {
        return saleCollRef
    }

    let sale <- DDDMarketplace.createSaleCollection(ownerCollection: ownerCollection, ownerVault: ownerVault)

    let saleRef = &sale as &DDDMarketplace.SaleCollection

    account.save(<-sale, to: DDDMarketplace.SaleCollectionStoragePath)

    account.link<&DDDMarketplace.SaleCollection>(DDDMarketplace.SaleCollectionPublicPath, target: DDDMarketplace.SaleCollectionStoragePath)

    return saleRef
}

// transaction to create a sale collection and
// link it with a public capability 
transaction(tokenID: UInt64, price: UFix64) {

    prepare(acct: AuthAccount) {
        let NFTCollectionProviderPrivatePath = /private/DDDNFTCollectionProvider

        let receiver = acct.getCapability<&FlowToken.Vault{FungibleToken.Receiver}>(FlowToken.ReceiverPublicPath)
        assert(receiver.borrow() != nil, message: "Missing or mis-typed FLOW receiver")


        if !acct.getCapability<&{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>(DDDNFT.CollectionPublicPath).check() {
            acct.link<&DDDNFT.Collection{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>(NFTCollectionProviderPrivatePath, target: DDDNFT.CollectionStoragePath)
        }

        let collectionCapability = acct.getCapability<&{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>(NFTCollectionProviderPrivatePath)
        assert(collectionCapability.borrow() != nil, message: "Missing or mis-typed DDDNFT.Collection provider")

        let saleRef = getOrCreateSaleCollection(account: acct, ownerCollection: collectionCapability, ownerVault: receiver)
        saleRef.listForSale(tokenID: tokenID, price: price)
        
    }
}