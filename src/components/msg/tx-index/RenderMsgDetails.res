module Calldata = {
  @react.component
  let make = (~schema, ~calldata) => {
    let failed =
      <Text
        value="Could not decode calldata."
        spacing=Text.Em(0.02)
        nowrap=true
        ellipsis=true
        code=true
        block=true
        size=Text.Body1
      />
    <>
      <div className={Css.merge(list{CssHelper.flexBox(~justify=#flexEnd, ()), CssHelper.mb()})}>
        <CopyButton
          data={calldata->JsBuffer.toHex(~with0x=false)} title="Copy as bytes" width=125
        />
      </div>
      {Obi.decode(schema, "input", calldata)->Belt.Option.mapWithDefault(failed, calldataKVs =>
        <KVTable
          rows={calldataKVs->Belt.Array.map(({fieldName, fieldValue}) => [
            KVTable.Value(fieldName),
            KVTable.Value(fieldValue),
          ])}
        />
      )}
    </>
  }
}

type content_inner_t =
  | PlainText(string)
  | Address(Address.t)
  | ValidatorAddress(Address.t)
  | Calldata(string, JsBuffer.t)
  | Coin(Belt.List.t<Coin.t>)
  | ID(React.element) // TODO: refactor not to receive react.element
  | RawReports(Belt.List.t<Msg.RawDataReport.t>)
  | Timestamp(MomentRe.Moment.t)

type content_t = {
  title: string,
  content: content_inner_t,
  order: int,
}

let renderValue = v => {
  switch v {
  | Address(address) => <AddressRender position=AddressRender.Subtitle address />
  | ValidatorAddress(address) => <AddressRender position=AddressRender.Subtitle address />
  | PlainText(content) => <Text value={content} size=Text.Body1 />
  | Coin(amount) => <AmountRender coins={amount} />
  | ID(element) => element
  | Calldata(schema, data) => <Calldata schema calldata=data />
  | RawReports(data) =>
    <KVTable
      headers=["External Id", "Exit Code", "Value"]
      rows={data
      ->Belt.List.toArray
      ->Belt.Array.map(rawReport => [
        KVTable.Value(rawReport.externalDataID->string_of_int),
        KVTable.Value(rawReport.exitCode->string_of_int),
        KVTable.Value(rawReport.data->JsBuffer.toUTF8),
      ])}
    />
  | Timestamp(timestamp) => <Timestamp time={timestamp} size=Text.Body1 />
  }
}

module CreateDataSource = {
  let factory = (msg: Msg.CreateDataSource.t<'a>, firsts) =>
    firsts->Belt.Array.concat([
      {title: "Owner", content: Address(msg.owner), order: 2},
      {title: "Treasury", content: Address(msg.treasury), order: 3},
      {title: "Fee", content: Coin(msg.fee), order: 4},
    ])

  let success = (msg: Msg.CreateDataSource.success_t) =>
    msg->factory([
      {
        title: "ID",
        content: ID(
          <div className={CssHelper.flexBox()}>
            <TypeID.DataSource position=TypeID.Subtitle id={msg.id} />
            <HSpacing size=Spacing.sm />
            <Text value={msg.name} size=Text.Body1 />
          </div>,
        ),
        order: 1,
      },
    ])

  let failed = (msg: Msg.CreateDataSource.failed_t) =>
    msg->factory([
      {
        title: "Name",
        content: PlainText(msg.name),
        order: 1,
      },
    ])
}

module Request = {
  let factory = (msg: Msg.Request.t<'a, 'b, 'c>, firsts) =>
    firsts->Belt.Array.concat([
      {
        title: "Owner",
        content: Address(msg.sender),
        order: 3,
      },
      {
        title: "Fee Limit",
        content: Coin(msg.feeLimit),
        order: 4,
      },
      {
        title: "Prepare Gas",
        content: PlainText(msg.prepareGas->Belt.Int.toString),
        order: 5,
      },
      {
        title: "Execute Gas",
        content: PlainText(msg.executeGas->Belt.Int.toString),
        order: 6,
      },
      {
        title: "Request Validator Count",
        content: PlainText(msg.askCount->Belt.Int.toString),
        order: 7,
      },
      {
        title: "Sufficient Validator Count",
        content: PlainText(msg.minCount->Belt.Int.toString),
        order: 8,
      },
    ])

  let success = (msg: Msg.Request.success_t) =>
    msg->factory([
      {
        title: "Request ID",
        content: ID(<TypeID.Request position=TypeID.Subtitle id={msg.id} />),
        order: 1,
      },
      {
        title: "Oracle Script ID",
        content: ID(
          <div className={CssHelper.flexBox()}>
            <TypeID.OracleScript position=TypeID.Subtitle id={msg.oracleScriptID} />
            <HSpacing size=Spacing.sm />
            <Text value={msg.oracleScriptName} size=Text.Body1 />
          </div>,
        ),
        order: 2,
      },
      {
        title: "Calldata",
        content: Calldata(msg.schema, msg.calldata),
        order: 9,
      },
    ])

  let failed = (msg: Msg.Request.failed_t) => msg->factory([])
}

module EditDataSource = {
  let factory = (msg: Msg.EditDataSource.t) => [
    {
      title: "Name",
      content: ID(
        <div className={CssHelper.flexBox()}>
          <TypeID.DataSource position=TypeID.Subtitle id={msg.id} />
          <HSpacing size=Spacing.sm />
          <Text value={msg.name} size=Text.Body1 />
        </div>,
      ),
      order: 1,
    },
    {
      title: "Owner",
      content: Address(msg.owner),
      order: 2,
    },
    {
      title: "Treasury",
      content: Address(msg.treasury),
      order: 3,
    },
    {
      title: "Fee",
      content: Coin(msg.fee),
      order: 4,
    },
  ]
}

module CreateOracleScript = {
  let factory = (msg: Msg.CreateOracleScript.t<'a>, firsts) =>
    firsts->Belt.Array.concat([{title: "Owner", content: Address(msg.owner), order: 2}])

  let success = (msg: Msg.CreateOracleScript.success_t) =>
    msg->factory([
      {
        title: "ID",
        content: ID(
          <div className={CssHelper.flexBox()}>
            <TypeID.OracleScript position=TypeID.Subtitle id={msg.id} />
            <HSpacing size=Spacing.sm />
            <Text value={msg.name} size=Text.Body1 />
          </div>,
        ),
        order: 1,
      },
    ])

  let failed = (msg: Msg.CreateOracleScript.failed_t) =>
    msg->factory([
      {
        title: "Name",
        content: PlainText(msg.name),
        order: 1,
      },
    ])
}

module EditOracleScript = {
  let factory = (msg: Msg.EditOracleScript.t) => [
    {
      title: "Name",
      content: ID(
        <div className={CssHelper.flexBox()}>
          <TypeID.OracleScript position=TypeID.Subtitle id={msg.id} />
          <HSpacing size=Spacing.sm />
          <Text value={msg.name} size=Text.Body1 />
        </div>,
      ),
      order: 1,
    },
    {
      title: "Owner",
      content: Address(msg.owner),
      order: 2,
    },
  ]
}

module Send = {
  let factory = (msg: Msg.Send.t) => [
    {
      title: "From",
      content: Address(msg.fromAddress),
      order: 1,
    },
    {
      title: "To",
      content: Address(msg.toAddress),
      order: 2,
    },
    {
      title: "Amount",
      content: Coin(msg.amount),
      order: 5,
    },
  ]
}

module Report = {
  let factory = (msg: Msg.Report.t) => [
    {
      title: "Request ID",
      content: ID(<TypeID.Request position=TypeID.Subtitle id={msg.requestID} />),
      order: 1,
    },
    {
      title: "Reporter",
      content: Address(msg.reporter),
      order: 2,
    },
    {
      title: "Raw Data Report",
      content: RawReports(msg.rawReports),
      order: 5,
    },
  ]
}

module Grant = {
  let factory = (msg: Msg.Grant.t) => [
    {
      title: "Granter",
      content: Address(msg.validator),
      order: 1,
    },
    {
      title: "Grantee",
      content: Address(msg.reporter),
      order: 2,
    },
    {
      title: "Authorization URL",
      content: PlainText(msg.url),
      order: 5,
    },
    {
      title: "Expiration Date",
      content: Timestamp(msg.expiration),
      order: 5,
    },
  ]
}

let getContent = msg => {
  switch msg {
  | Msg.CreateDataSourceMsg(m) =>
    switch m {
    | Msg.CreateDataSource.Success(data) => CreateDataSource.success(data)
    | Msg.CreateDataSource.Failure(data) => CreateDataSource.failed(data)
    }
  | Msg.EditDataSourceMsg(data) => EditDataSource.factory(data)

  | Msg.CreateOracleScriptMsg(m) =>
    switch m {
    | Msg.CreateOracleScript.Success(data) => CreateOracleScript.success(data)
    | Msg.CreateOracleScript.Failure(data) => CreateOracleScript.failed(data)
    }
  | Msg.EditOracleScriptMsg(data) => EditOracleScript.factory(data)
  | Msg.RequestMsg(m) =>
    switch m {
    | Msg.Request.Success(data) => Request.success(data)
    | Msg.Request.Failure(data) => Request.failed(data)
    }
  | Msg.SendMsg(data) => Send.factory(data)
  | Msg.ReportMsg(data) => Report.factory(data)
  | Msg.GrantMsg(data) => Grant.factory(data)
  | Msg.UnknownMsg => []
  }
}

@react.component
let make = (~contents: array<content_t>) => {
  let ({ThemeContext.theme: theme}, _) = React.useContext(ThemeContext.context)

  {
    contents
    ->Belt.SortArray.stableSortBy((a, b) => a.order - b.order)
    ->Belt.Array.mapWithIndex((i, content) => {
      <Row key={i->Belt.Int.toString}>
        <Col col=Col.Three mb=24>
          <Heading
            value={content.title}
            size=Heading.H4
            weight=Heading.Regular
            marginBottom=8
            color=theme.neutral_600
          />
        </Col>
        <Col col=Col.Nine mb=24 key={i->Belt.Int.toString}> {renderValue(content.content)} </Col>
      </Row>
    })
    ->React.array
  }
}
