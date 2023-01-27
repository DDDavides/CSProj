import NonFungibleToken from "../../Contracts/NonFungibleToken.cdc"
import DDDNFT from "../../Contracts/DDDNFT.cdc"
import MetadataViews from "../../Contracts/MetadataViews.cdc"
import FungibleToken from "../../Contracts/Utility/FungibleToken.cdc"

/// This script uses the NFTMinter resource to mint a new NFT
/// It must be run with the account that has the minter resource
/// stored in /storage/NFTMinter

transaction(
    recipient: Address,
    name: String,
    description: String,
    thumbnail: String,
    health: UFix64,
    attack: UFix64,
    defence: UFix64,
    cuts: [UFix64],
    royaltyDescriptions: [String],
    // royaltyBeneficiaries: [Address] 
) {

    /// local variable for storing the minter reference
    let minter: &DDDNFT.NFTMinter

    /// Reference to the receiver's collection
    let recipientCollectionRef: &{NonFungibleToken.CollectionPublic}

    /// Previous NFT ID before the transaction executes
    let mintingIDBefore: UInt64

    prepare(signer: AuthAccount) {
        self.mintingIDBefore = DDDNFT.totalSupply

        // borrow a reference to the NFTMinter resource in storage
        self.minter = signer.borrow<&DDDNFT.NFTMinter>(from: DDDNFT.MinterStoragePath)
            ?? panic("Account does not store an object at the specified path")

        // Borrow the recipient's public NFT collection reference
        self.recipientCollectionRef = getAccount(recipient)
            .getCapability(DDDNFT.CollectionPublicPath)
            .borrow<&{NonFungibleToken.CollectionPublic}>()
            ?? panic("Could not get receiver reference to the NFT Collection")
    }

    pre {
        // cuts.length == royaltyDescriptions.length && cuts.length == royaltyBeneficiaries.length: "Array length should be equal for royalty related details"
    }

    execute {

        // Create the royalty details
        var count = 0
        // var royalties: [MetadataViews.Royalty] = []
        // while royaltyBeneficiaries.length > count {
        //     let beneficiary = royaltyBeneficiaries[count]
        //     let beneficiaryCapability = getAccount(beneficiary)
        //     .getCapability<&{FungibleToken.Receiver}>(MetadataViews.getRoyaltyReceiverPublicPath())

        //     // Make sure the royalty capability is valid before minting the NFT
        //     if !beneficiaryCapability.check() { panic("Beneficiary capability is not valid!") }

        //     royalties.append(
        //         MetadataViews.Royalty(
        //             receiver: beneficiaryCapability,
        //             cut: cuts[count],
        //             description: royaltyDescriptions[count]
        //         )
        //     )
        //     count = count + 1
        // }



        // Mint the NFT and deposit it to the recipient's collection
        self.minter.mintNFT(
            recipient: self.recipientCollectionRef,
            name: name,
            description: description,
            thumbnail: thumbnail,
            health: health,
            attack: attack,
            defence: defence,
            royalties: []
        )
    }

    post {
        self.recipientCollectionRef.getIDs().contains(self.mintingIDBefore): "The next NFT ID should have been minted and delivered"
        DDDNFT.totalSupply == self.mintingIDBefore + 1: "The total supply should have been increased by 1"
    }
}
 