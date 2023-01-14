import Player from "../Contracts/Player.cdc"

transaction {
    var id: UInt64
    var name: String


    prepare(acct: AuthAccount) {

        let player = acct.borrow<&Player.PlayerNFT>(from: /storage/PlayerNFT) ?? panic("No resource")
        self.id = player.getId()
        self.name = player.getName()
    }
    execute {
        log("id = ".concat(self.id.toString()))
        log("name = ".concat(self.name))
    }
}