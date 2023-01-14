import ExampleNFT from "../Contracts/ExampleNFT.cdc"

pub fun main(): UInt64 {
    return ExampleNFT.totalSupply
}
