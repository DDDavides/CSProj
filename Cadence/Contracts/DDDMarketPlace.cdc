import FungibleToken from "./Utility/FungibleToken.cdc"
import NonFungibleToken from "./NonFungibleToken.cdc"

pub contract DDDMarketplace {

    // Events for marketplace 
    //
    pub event ForSale(id: UInt64, price: UFix64, owner: Address?)
    pub event PriceChanged(id: UInt64, newPrice: UFix64, owner: Address?)
    pub event TokenPurchased(id: UInt64, price: UFix64, seller: Address?)
    pub event SaleCanceled(id: UInt64, seller: Address?)

    pub let SaleCollectionPublicPath: PublicPath
    pub let SaleCollectionStoragePath: StoragePath

    // Interface that exposes the public
    // methods of the sale
    pub resource interface SalePublic {
        pub fun purchase(tokenID: UInt64, buyTokens: @FungibleToken.Vault): @NonFungibleToken.NFT
	    pub fun idPrice(tokenID: UInt64): UFix64?	        
        pub fun getIDs(): [UInt64] 
    }

    // SaleCollection
    //
    pub resource SaleCollection: SalePublic  {
    
        /// A capability for the owner's collection
        access(self) var ownerCollection: Capability<&{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>

        // Dictionary of the prices for each NFT by ID
        access(self) var prices: {UInt64: UFix64}

        // The fungible token vault of the owner of this sale.
        // When someone buys a token, this resource can deposit
        // tokens into their account.
        access(account) let ownerVault: Capability<&AnyResource{FungibleToken.Receiver}>

        init (ownerCollection: Capability<&{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>,
              ownerVault: Capability<&AnyResource{FungibleToken.Receiver}>) {

            pre {
                // Check that the owner's collection capability is correct
                ownerCollection.check():
                    "Owner's NFT Collection Capability is invalid!"

                // Check that the fungible token vault capability is correct
                ownerVault.check():
                    "Owner's Receiver Capability is invalid!"
            }
            self.ownerCollection = ownerCollection
            self.ownerVault = ownerVault
            self.prices = {}
        }

        // cancelSale gives the owner the opportunity to cancel a sale in the collection
        pub fun cancelSale(tokenID: UInt64) {
            // remove the price
            self.prices.remove(key: tokenID)
            self.prices[tokenID] = nil
        }

        // listForSale lists an NFT for sale in this collection
        pub fun listForSale(tokenID: UInt64, price: UFix64) {
            pre {
                self.ownerCollection.borrow()!.idExists(id: tokenID):
                    "NFT to be listed does not exist in the owner's collection"
            }
            // store the price in the price array
            self.prices[tokenID] = price

            emit ForSale(id: tokenID, price: price, owner: self.owner?.address)
        }

        // changePrice changes the price of a token that is currently for sale
        pub fun changePrice(tokenID: UInt64, newPrice: UFix64) {
            self.prices[tokenID] = newPrice

            emit PriceChanged(id: tokenID, newPrice: newPrice, owner: self.owner?.address)
        }

        // purchase lets a user send tokens to purchase an NFT that is for sale
        pub fun purchase(tokenID: UInt64, buyTokens: @FungibleToken.Vault): @NonFungibleToken.NFT {
            pre {
                self.prices[tokenID] != nil:
                    "No token matching this ID for sale!"
                buyTokens.balance >= (self.prices[tokenID] ?? 0.0):
                    "Not enough tokens to by the NFT!"
            }

            // get the value out of the optional
            let price = self.prices[tokenID]!

            self.prices[tokenID] = nil

            let vaultRef = self.ownerVault.borrow()
                ?? panic("Could not borrow reference to owner token vault")

            // deposit the purchasing tokens into the owners vault
            vaultRef.deposit(from: <-buyTokens)

            emit TokenPurchased(id: tokenID, price: price, seller: self.owner?.address)
            return <-self.ownerCollection.borrow()!.withdraw(withdrawID: tokenID)
        }

        // idPrice returns the price of a specific token in the sale
        pub fun idPrice(tokenID: UInt64): UFix64? {
            return self.prices[tokenID]
        }

        // getIDs returns an array of token IDs that are for sale
        pub fun getIDs(): [UInt64] {
            return self.prices.keys
        }
    }

    // createCollection returns a new collection resource to the caller
    pub fun createSaleCollection(ownerCollection: Capability<&{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>,
                                 ownerVault: Capability<&AnyResource{FungibleToken.Receiver}>): @SaleCollection {
        return <- create SaleCollection(ownerCollection: ownerCollection, ownerVault: ownerVault)
    }

     init () {
        self.SaleCollectionStoragePath = /storage/SaleCollection
        self.SaleCollectionPublicPath = /public/SaleCollection
    }
}