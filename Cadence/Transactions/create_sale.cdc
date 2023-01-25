import FlowToken from "../Contracts/Utility/FlowToken.cdc"
import FungibleToken from "../Contracts/Utility/FungibleToken.cdc"
import DDDNFT from "../Contracts/DDDNFT.cdc"
import NonFungibleToken from "../Contracts/NonFungibleToken.cdc"
import DDDMarketplace from "../Contracts/DDDMarketplace.cdc"

pub fun getOrCreateSaleCollection(account: AuthAccount, ownerCollection: Capability<&NonFungibleToken.Collection>, ownerVault: Capability<&AnyResource{FungibleToken.Receiver}>): &DDDMarketplace.SaleCollection{
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
        
        let receiver = acct.getCapability<&{FungibleToken.Receiver}>(FlowToken.VaultReceiverPublicPath)
        let collectionCapability = acct.getCapability<&DDDNFT.Collection>(DDDNFT.CollectionPublicPath)
        
        let saleRef = getOrCreateSaleCollection(account: acct, ownerCollection: collectionCapability, ownerVault: receiver)
        saleRef.listForSale(tokenID: tokenID, price: price)
        
    }
}