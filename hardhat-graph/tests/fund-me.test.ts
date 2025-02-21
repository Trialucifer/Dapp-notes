import {
  assert,
  describe,
  test,
  clearStore,
  beforeAll,
  afterAll
} from "matchstick-as/assembly/index"
import { Address, BigInt } from "@graphprotocol/graph-ts"
import { FundLog } from "../generated/schema"
import { FundLog as FundLogEvent } from "../generated/FundMe/FundMe"
import { handleFundLog } from "../src/fund-me"
import { createFundLogEvent } from "./fund-me-utils"

// Tests structure (matchstick-as >=0.5.0)
// https://thegraph.com/docs/en/developer/matchstick/#tests-structure-0-5-0

describe("Describe entity assertions", () => {
  beforeAll(() => {
    let _addr = Address.fromString("0x0000000000000000000000000000000000000001")
    let amount = BigInt.fromI32(234)
    let newFundLogEvent = createFundLogEvent(_addr, amount)
    handleFundLog(newFundLogEvent)
  })

  afterAll(() => {
    clearStore()
  })

  // For more test scenarios, see:
  // https://thegraph.com/docs/en/developer/matchstick/#write-a-unit-test

  test("FundLog created and stored", () => {
    assert.entityCount("FundLog", 1)

    // 0xa16081f360e3847006db660bae1c6d1b2e17ec2a is the default address used in newMockEvent() function
    assert.fieldEquals(
      "FundLog",
      "0xa16081f360e3847006db660bae1c6d1b2e17ec2a-1",
      "_addr",
      "0x0000000000000000000000000000000000000001"
    )
    assert.fieldEquals(
      "FundLog",
      "0xa16081f360e3847006db660bae1c6d1b2e17ec2a-1",
      "amount",
      "234"
    )

    // More assert options:
    // https://thegraph.com/docs/en/developer/matchstick/#asserts
  })
})
