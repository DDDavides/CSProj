import DDDNFT from "../Contracts/DDDNFT.cdc"

pub fun main(): UInt64 {
    return DDDNFT.totalSupply
}
