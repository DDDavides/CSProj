import FlowToken from "../../Contracts/Utility/FlowToken.cdc"
import FungibleToken from "../../Contracts/Utility/FungibleToken.cdc"
import DDDNFT from "../../Contracts/DDDNFT.cdc"
import NonFungibleToken from "../../Contracts/NonFungibleToken.cdc"
import DDDMarketplace from "../../Contracts/DDDMarketplace.cdc"

transaction {
    prepare(acct: AuthAccount) {

        // If the account doesn't already have a salecollection
        if acct.borrow<&DDDMarketplace.SaleCollection>(from: DDDMarketplace.SaleCollectionStoragePath) == nil {

            // Create a new empty Storefront
            let receiver = acct.getCapability<&{FungibleToken.Receiver}>(FlowToken.ReceiverPublicPath)
            let collectionCapability = acct.getCapability<&{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>(DDDNFT.CollectionPublicPath)
            // save it to the account
            let sale <- DDDMarketplace.createSaleCollection(ownerCollection: collectionCapability, ownerVault: receiver)

            acct.save(<-sale, to: DDDMarketplace.SaleCollectionStoragePath)

            acct.link<&DDDMarketplace.SaleCollection>(DDDMarketplace.SaleCollectionPublicPath, target: DDDMarketplace.SaleCollectionStoragePath)


            // create a public capability for the Storefront
            acct.link<&DDDMarketplace.SaleCollection{DDDMarketplace.SalePublic}>(DDDMarketplace.SaleCollectionPublicPath, target: DDDMarketplace.SaleCollectionStoragePath)
        }
    }
}