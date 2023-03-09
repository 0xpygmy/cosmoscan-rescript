module Styles = {
  open CssJs

  let tableWrapper = style(. [Media.mobile([padding2(~v=#px(16), ~h=#zero)])])
}

let transform = (account, msg: Msg.t) => {
  // TODO: Bring it back when defind ReceiveMsg
  // let transformDecoded = switch decoded {
  // | SendMsg({toAddress, fromAddress, amount}) if Address.isEqual(toAddress, account) =>
  //   MsgDecoder.ReceiveMsg({toAddress, fromAddress, amount})
  // | _ => decoded
  // }
  // open MsgDecoder
  // {raw, decoded: transformDecoded, isIBC: transformDecoded->MsgDecoder.isIBC}
  msg
}

@react.component
let make = (~accountAddress: Address.t) => {
  let (page, setPage) = React.useState(_ => 1)
  let pageSize = 10

  let txsSub = TxSub.getListBySender(~sender=accountAddress, ~pageSize, ~page)
  let txsCountSub = TxSub.countBySender(accountAddress)

  let isMobile = Media.isMobile()

  <div className=Styles.tableWrapper>
    {isMobile
      ? <Row marginBottom=16>
          <Col>
            {switch txsCountSub {
            | Data(txsCount) =>
              <div className={CssHelper.flexBox()}>
                <Text
                  block=true
                  value={txsCount->Belt.Int.toString}
                  weight=Text.Semibold
                  size=Text.Caption
                />
                <HSpacing size=Spacing.xs />
                <Text
                  block=true
                  value="Transactions"
                  weight=Text.Semibold
                  size=Text.Caption
                  transform=Text.Uppercase
                />
              </div>
            | _ => <LoadingCensorBar width=100 height=15 />
            }}
          </Col>
        </Row>
      : <THead>
          <Row alignItems=Row.Center>
            <Col col=Col.Three>
              {switch txsCountSub {
              | Data(txsCount) =>
                <div className={CssHelper.flexBox()}>
                  <Text block=true value={txsCount->Belt.Int.toString} weight=Text.Semibold />
                  <HSpacing size=Spacing.xs />
                  <Text
                    block=true
                    value="Transactions"
                    weight=Text.Semibold
                    size=Text.Caption
                    transform=Text.Uppercase
                  />
                </div>
              | _ => <LoadingCensorBar width=100 height=15 />
              }}
            </Col>
            <Col col=Col.One>
              <Text
                block=true
                value="Block"
                weight=Text.Semibold
                size=Text.Caption
                transform=Text.Uppercase
              />
            </Col>
            <Col col=Col.One>
              <Text
                block=true
                value="Status"
                size=Text.Caption
                transform=Text.Uppercase
                weight=Text.Semibold
                align=Text.Center
              />
            </Col>
            <Col col=Col.Two>
              <Text
                block=true
                value="Gas Fee (BAND)"
                weight=Text.Semibold
                size=Text.Caption
                transform=Text.Uppercase
              />
            </Col>
            <Col col=Col.Five>
              <Text
                block=true
                value="Actions"
                weight=Text.Semibold
                size=Text.Caption
                transform=Text.Uppercase
              />
            </Col>
          </Row>
        </THead>}
    <TxsTable txsSub msgTransform={transform(accountAddress)} />
    {switch txsCountSub {
    | Data(txsCount) =>
      let pageCount = Page.getPageCount(txsCount, pageSize)
      <Pagination currentPage=page pageCount onPageChange={newPage => setPage(_ => newPage)} />
    | _ => React.null
    }}
  </div>
}
