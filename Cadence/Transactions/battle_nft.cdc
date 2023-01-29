import NonFungibleToken from "../Contracts/NonFungibleToken.cdc"
import DDDNFT from "../Contracts/DDDNFT.cdc"

transaction(attkrNFTID: UInt64,  dfndrNFTID: UInt64, 
    attkrAttkExtr: UFix64, attkrDefExtr: UFix64, 
    dfndrAttkExtr: UFix64, dfndrDefExtr: UFix64) {
    
    let attacker: AuthAccount
    let attkrNFTRef: &DDDNFT.NFT
    let attkrRef: &DDDNFT.Collection

    let defender: AuthAccount
    let dfndrNFTRef: &DDDNFT.NFT
    let dfndrRef: &DDDNFT.Collection

    // transazione con due firmatari
    prepare(attacker: AuthAccount, defender: AuthAccount) {
        
        if attkrAttkExtr > 1.0 || attkrDefExtr > 1.0 {
            panic("Attaker extraction error") 
        } 
        if dfndrAttkExtr > 1.0 || dfndrDefExtr > 1.0 {
            panic("Defender extraction error")
        }
        
        self.attacker = attacker
        self.attkrRef = attacker.borrow<&DDDNFT.Collection>(from: DDDNFT.CollectionStoragePath)
            ?? panic("Attacker account does not store an object at the specified path")
        self.dfndrRef = defender.borrow<&DDDNFT.Collection>(from: DDDNFT.CollectionStoragePath)
            ?? panic("Defender account does not store an object at the specified path")
        
        self.defender = defender
        self.attkrNFTRef = self.attkrRef.borrowDDDNFT(id: attkrNFTID) 
            ?? panic("No attacker NFT founded")
        self.dfndrNFTRef = self.dfndrRef.borrowDDDNFT(id: dfndrNFTID) 
            ?? panic("No defender NFT founded")
    }
    execute {
        // statistiche dell'attaccante
        let attkrAttack = self.attkrNFTRef.attack * attkrAttkExtr
        let attkrDefence = self.attkrNFTRef.defence * attkrDefExtr

        // statistiche del difensore
        let dfndrAttack = self.dfndrNFTRef.attack * dfndrAttkExtr
        let dfndrDefence = self.dfndrNFTRef.defence * dfndrDefExtr

        // danni inflitti da attaccante e difensore ad ogni colpo
        let attkrDamage = (attkrAttack).saturatingSubtract(dfndrDefence)
        let dfndrDamage = (dfndrAttack).saturatingSubtract(attkrDefence)
        
        if (attkrDamage == 0.0) && (dfndrDamage == 0.0) {
            panic("No Winner, Attacker and Defender don't have enough damage!")
        }

        // calcolo dei colpi che ogniuno dei due deve infliggere all'altro
        // per vincere la bataglia
        let epsilon = 0.00001   //previene la divisione per 0
        let attkrHits = self.attkrNFTRef.health / (attkrDamage + epsilon)
        let dfndrHits = self.dfndrNFTRef.health / (dfndrDamage + epsilon)

        // calcolo del vincitore (l'attaccante attacca per primo)
        let attkrWin = attkrHits <= dfndrHits

        // per ora è possibile incrementare solo di uno
        let increment: UInt64 = 1
        if attkrWin {
            self.attkrNFTRef.incrementVictories(increment: increment)
            self.dfndrNFTRef.incrementDefeats(increment: increment)
        }
        else {
            self.dfndrNFTRef.incrementVictories(increment: increment)
            self.attkrNFTRef.incrementDefeats(increment: increment)
        }



        // incremento delle vittorie e log del vincitore
        var winnerName: String = ""
        var winnerAddress: Address = 0x0
        if attkrWin {
            winnerName = self.attkrNFTRef.name
            winnerAddress = self.attacker.address

        } else {
            winnerName = self.dfndrNFTRef.name
            winnerAddress = self.defender.address

        }
        
        log(winnerName.concat(" of ").concat(winnerAddress.toString()).concat(" won!"))
    }
}
 