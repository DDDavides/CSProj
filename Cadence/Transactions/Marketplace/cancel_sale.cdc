import FlowToken from "../../Contracts/Utility/FlowToken.cdc"
import FungibleToken from "../../Contracts/Utility/FungibleToken.cdc"
import DDDNFT from "../../Contracts/DDDNFT.cdc"
import NonFungibleToken from "../../Contracts/NonFungibleToken.cdc"
import DDDMarketplace from "../../Contracts/DDDMarketplace.cdc"


// transaction to create a sale collection and
// link it with a public capability 
transaction(tokenID: UInt64) {

    prepare(acct: AuthAccount) {

        let saleCollRef = acct.borrow<&DDDMarketplace.SaleCollection>(from: DDDMarketplace.SaleCollectionStoragePath) 
            ?? panic("SaleCollection not found")
        saleCollRef.cancelSale(tokenID: tokenID)
        
    }
}