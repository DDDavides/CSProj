pub contract Player {
    

    // Declare the PlayerNFT resource
    pub resource PlayerNFT {

        pub let id: UInt64

        pub var name:  String

        init(initID: UInt64, playerName: String){
            self.id = initID
            self.name = playerName
        }
        
    }

    // function to create a player NFT
    pub fun createPlayer(initID: UInt64, playerName: String): @PlayerNFT{
        return <- create PlayerNFT(initID: initID, playerName: playerName)
    }

    // function to initialize the contract
    init(name: String){
        self.account.save<@PlayerNFT>(<-create PlayerNFT(initID: 1, playerName: name), to: /storage/PlayerNFT)
    }

}