import {
  FundLog as FundLogEvent,
  FundWithdDrawByOwner as FundWithdDrawByOwnerEvent,
  RefundBalance as RefundBalanceEvent
} from "../generated/FundMe/FundMe"
import {
  FundLog,
  FundWithdDrawByOwner,
  RefundBalance
} from "../generated/schema"

export function handleFundLog(event: FundLogEvent): void {
  let entity = new FundLog(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity._addr = event.params._addr
  entity.amount = event.params.amount

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleFundWithdDrawByOwner(
  event: FundWithdDrawByOwnerEvent
): void {
  let entity = new FundWithdDrawByOwner(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.amount = event.params.amount

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleRefundBalance(event: RefundBalanceEvent): void {
  let entity = new RefundBalance(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity._addr = event.params._addr
  entity.amount = event.params.amount

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}
