import { newMockEvent } from "matchstick-as"
import { ethereum, Address, BigInt } from "@graphprotocol/graph-ts"
import {
  FundLog,
  FundWithdDrawByOwner,
  RefundBalance
} from "../generated/FundMe/FundMe"

export function createFundLogEvent(_addr: Address, amount: BigInt): FundLog {
  let fundLogEvent = changetype<FundLog>(newMockEvent())

  fundLogEvent.parameters = new Array()

  fundLogEvent.parameters.push(
    new ethereum.EventParam("_addr", ethereum.Value.fromAddress(_addr))
  )
  fundLogEvent.parameters.push(
    new ethereum.EventParam("amount", ethereum.Value.fromUnsignedBigInt(amount))
  )

  return fundLogEvent
}

export function createFundWithdDrawByOwnerEvent(
  amount: BigInt
): FundWithdDrawByOwner {
  let fundWithdDrawByOwnerEvent =
    changetype<FundWithdDrawByOwner>(newMockEvent())

  fundWithdDrawByOwnerEvent.parameters = new Array()

  fundWithdDrawByOwnerEvent.parameters.push(
    new ethereum.EventParam("amount", ethereum.Value.fromUnsignedBigInt(amount))
  )

  return fundWithdDrawByOwnerEvent
}

export function createRefundBalanceEvent(
  _addr: Address,
  amount: BigInt
): RefundBalance {
  let refundBalanceEvent = changetype<RefundBalance>(newMockEvent())

  refundBalanceEvent.parameters = new Array()

  refundBalanceEvent.parameters.push(
    new ethereum.EventParam("_addr", ethereum.Value.fromAddress(_addr))
  )
  refundBalanceEvent.parameters.push(
    new ethereum.EventParam("amount", ethereum.Value.fromUnsignedBigInt(amount))
  )

  return refundBalanceEvent
}
