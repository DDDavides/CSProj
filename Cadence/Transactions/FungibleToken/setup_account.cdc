// This transaction is a template for a transaction to allow 
// anyone to add a Vault resource to their account so that 
// they can use the FlowToken

import FungibleToken from "../../Contracts/Utility/FungibleToken.cdc"
import FlowToken from "../../Contracts/Utility/FlowToken.cdc"
import FungibleTokenMetadataViews from "../../Contracts/Utility/FungibleTokenMetadataViews.cdc"

transaction () {

    prepare(signer: AuthAccount) {

        // Return early if the account already stores a FlowToken Vault
        if signer.borrow<&FlowToken.Vault>(from: FlowToken.VaultStoragePath) != nil {
            return
        }

        // Create a new FlowToken Vault and put it in storage
        signer.save(
            <-FlowToken.createEmptyVault(),
            to: FlowToken.VaultStoragePath
        )

        // Create a public capability to the Vault that only exposes
        // the deposit function through the Receiver interface
        signer.link<&FlowToken.Vault{FungibleToken.Receiver}>(
            FlowToken.ReceiverPublicPath,
            target: FlowToken.VaultStoragePath
        )

        // Create a public capability to the Vault that exposes the Balance and Resolver interfaces
        signer.link<&FlowToken.Vault{FungibleToken.Balance}>(
            FlowToken.VaultPublicPath,
            target: FlowToken.VaultStoragePath
        )
    }
}