module Packet = {
  @react.component
  let make = (~packet: MsgDecoder.Packet.t) => {
    let ({ThemeContext.theme: theme}, _) = React.useContext(ThemeContext.context)
    <>
      <SeperatedLine mt=24 mb=24 />
      <Row>
        <Col mb=24>
          <Heading value="Packet" size=Heading.H4 color=theme.neutral_600 />
        </Col>
        <Col col=Col.Six mb=24>
          <Heading
            value="Source Port"
            size=Heading.H4
            marginBottom=8
            weight=Heading.Regular
            color=theme.neutral_600
          />
          <Text size=Text.Body1 value=packet.sourcePort />
        </Col>
        <Col col=Col.Six mb=24>
          <Heading
            value="Destination Port"
            size=Heading.H4
            marginBottom=8
            weight=Heading.Regular
            color=theme.neutral_600
          />
          <Text size=Text.Body1 value=packet.destinationPort />
        </Col>
        <Col col=Col.Six mb=24>
          <Heading
            value="Source Channel"
            size=Heading.H4
            marginBottom=8
            weight=Heading.Regular
            color=theme.neutral_600
          />
          <Text size=Text.Body1 value=packet.sourceChannel />
        </Col>
        <Col col=Col.Six mb=24>
          <Heading
            value="Destination Channel"
            size=Heading.H4
            marginBottom=8
            weight=Heading.Regular
            color=theme.neutral_600
          />
          <Text size=Text.Body1 value=packet.destinationChannel />
        </Col>
        <Col col=Col.Six mbSm=24>
          <Heading
            value="Data"
            size=Heading.H4
            marginBottom=8
            weight=Heading.Regular
            color=theme.neutral_600
          />
          <Text size=Text.Body1 value=packet.data breakAll=true />
        </Col>
        <Col col=Col.Six mbSm=24>
          <Heading
            value="Timeout Timestamp"
            size=Heading.H4
            marginBottom=8
            weight=Heading.Regular
            color=theme.neutral_600
          />
          <Timestamp time=packet.timeoutTimestamp size=Text.Body1 />
        </Col>
      </Row>
    </>
  }
}

module OracleRequestPacket = {
  @react.component
  let make = (~request: PacketDecoder.OracleRequestPacket.t, ~packetType) => {
    let ({ThemeContext.theme: theme}, _) = React.useContext(ThemeContext.context)
    let calldataKVsOpt = Obi.decode(request.schema, "input", request.calldata)
    <>
      <SeperatedLine mt=24 mb=24 />
      <Row>
        <Col mb=24>
          <Heading value="Packet Data" size=Heading.H4 color=theme.neutral_600 />
        </Col>
        <Col mb=24>
          <Heading
            value="Packet Type"
            size=Heading.H4
            weight=Heading.Regular
            marginBottom=8
            color=theme.neutral_600
          />
          <Text size=Text.Body1 value=packetType />
        </Col>
        <Col col=Col.Six mb=24>
          <Heading
            value="Request ID"
            size=Heading.H4
            weight=Heading.Regular
            marginBottom=8
            color=theme.neutral_600
          />
          <TypeID.Request position=TypeID.Subtitle id=request.requestID />
        </Col>
        <Col col=Col.Six mb=24>
          <Heading
            value="Oracle Script"
            size=Heading.H4
            weight=Heading.Regular
            marginBottom=8
            color=theme.neutral_600
          />
          <div className={CssHelper.flexBox()}>
            <TypeID.OracleScript position=TypeID.Subtitle id=request.oracleScriptID />
            <HSpacing size=Spacing.sm />
            <Text value=request.oracleScriptName size=Text.Body1 />
          </div>
        </Col>
        <Col col=Col.Six mb=24>
          <Heading
            value="Prepare Gas"
            size=Heading.H4
            weight=Heading.Regular
            marginBottom=8
            color=theme.neutral_600
          />
          <Text value={request.prepareGas->Belt.Int.toString} size=Text.Body1 />
        </Col>
        <Col col=Col.Six mb=24>
          <Heading
            value="Execute Gas"
            size=Heading.H4
            weight=Heading.Regular
            marginBottom=8
            color=theme.neutral_600
          />
          <Text value={request.executeGas->Belt.Int.toString} size=Text.Body1 />
        </Col>
        <Col mb=24>
          <div
            className={Css.merge(list{
              CssHelper.flexBox(~justify=#spaceBetween, ()),
              CssHelper.mb(),
            })}>
            <Heading
              value="Calldata" size=Heading.H4 weight=Heading.Regular color=theme.neutral_600
            />
            <CopyButton
              data={request.calldata->JsBuffer.toHex(~with0x=false)} title="Copy as bytes" width=125
            />
          </div>
          {switch calldataKVsOpt {
          | Some(calldataKVs) =>
            <KVTable
              rows={calldataKVs->Belt.Array.map(({fieldName, fieldValue}) => [
                KVTable.Value(fieldName),
                KVTable.Value(fieldValue),
              ])}
            />
          | None =>
            <Text
              value="Could not decode calldata."
              spacing=Text.Em(0.02)
              nowrap=true
              ellipsis=true
              code=true
              block=true
              size=Text.Body1
            />
          }}
        </Col>
        <Col col=Col.Six mbSm=24>
          <Heading
            value="Request Validator Count"
            size=Heading.H4
            weight=Heading.Regular
            marginBottom=8
            color=theme.neutral_600
          />
          <Text value={request.askCount->Belt.Int.toString} size=Text.Body1 />
        </Col>
        <Col col=Col.Six>
          <Heading
            value="Sufficient Validator Count"
            size=Heading.H4
            weight=Heading.Regular
            marginBottom=8
            color=theme.neutral_600
          />
          <Text value={request.minCount->Belt.Int.toString} size=Text.Body1 />
        </Col>
      </Row>
    </>
  }
}

module FungibleTokenPacket = {
  @react.component
  let make = (~token: PacketDecoder.FungibleTokenPacket.t, ~packetType) => {
    let ({ThemeContext.theme: theme}, _) = React.useContext(ThemeContext.context)
    <>
      <SeperatedLine mt=24 mb=24 />
      <Row>
        <Col mb=24>
          <Heading value="Packet Data" size=Heading.H4 color=theme.neutral_600 />
        </Col>
        <Col mb=24>
          <Heading
            value="Packet Type"
            size=Heading.H4
            weight=Heading.Regular
            marginBottom=8
            color=theme.neutral_600
          />
          <Text size=Text.Body1 value=packetType />
        </Col>
        <Col col=Col.Six mb=24>
          <Heading
            value="Sender"
            size=Heading.H4
            weight=Heading.Regular
            marginBottom=8
            color=theme.neutral_600
          />
          <Text size=Text.Body1 value=token.sender />
        </Col>
        <Col col=Col.Six mb=24>
          <Heading
            value="Receiver"
            size=Heading.H4
            weight=Heading.Regular
            marginBottom=8
            color=theme.neutral_600
          />
          <Text size=Text.Body1 value=token.receiver />
        </Col>
        <Col col=Col.Six mb=24>
          <Heading
            value="Amount"
            size=Heading.H4
            weight=Heading.Regular
            marginBottom=8
            color=theme.neutral_600
          />
          <Text
            value={token.amount->Belt.Int.toString ++ (" " ++ token.denom)}
            code=true
            size=Text.Body2
            nowrap=true
            block=true
          />
        </Col>
      </Row>
    </>
  }
}

module RecvPacketSuccess = {
  @react.component
  let make = (~packet: MsgDecoder.RecvPacket.success_t) => {
    let ({ThemeContext.theme: theme}, _) = React.useContext(ThemeContext.context)
    <>
      <Row>
        <Col col=Col.Six mbSm=24>
          <Heading
            value="Signer"
            size=Heading.H4
            weight=Heading.Regular
            marginBottom=8
            color=theme.neutral_600
          />
          <AddressRender address=packet.signer />
        </Col>
      </Row>
      <IndexIBCUtils.ProofHeight proofHeight=packet.proofHeight />
      <Packet packet=packet.packet />
      {switch packet.packetData.packetDetail {
      | OracleRequestPacket(request) =>
        <OracleRequestPacket request packetType=packet.packetData.packetType />
      | FungibleTokenPacket(token) =>
        <FungibleTokenPacket token packetType=packet.packetData.packetType />
      | _ => React.null
      }}
    </>
  }
}

module RecvPacketFail = {
  @react.component
  let make = (~packet: MsgDecoder.RecvPacket.fail_t) => {
    let ({ThemeContext.theme: theme}, _) = React.useContext(ThemeContext.context)
    <>
      <Row>
        <Col>
          <Heading
            value="Signer"
            size=Heading.H4
            weight=Heading.Regular
            marginBottom=8
            color=theme.neutral_600
          />
          <AddressRender address=packet.signer />
        </Col>
      </Row>
      <IndexIBCUtils.ProofHeight proofHeight=packet.proofHeight />
      <Packet packet=packet.packet />
    </>
  }
}

module AcknowledgePacket = {
  @react.component
  let make = (~packet: MsgDecoder.AcknowledgePacket.t) => {
    let ({ThemeContext.theme: theme}, _) = React.useContext(ThemeContext.context)
    <>
      <Row>
        <Col>
          <Heading
            value="Signer"
            size=Heading.H4
            marginBottom=8
            weight=Heading.Regular
            color=theme.neutral_600
          />
          <AddressRender address=packet.signer />
        </Col>
      </Row>
      <IndexIBCUtils.ProofHeight proofHeight=packet.proofHeight />
      <Packet packet=packet.packet />
    </>
  }
}

module Timeout = {
  @react.component
  let make = (~packet: MsgDecoder.Timeout.t) => {
    let ({ThemeContext.theme: theme}, _) = React.useContext(ThemeContext.context)
    <>
      <Row>
        <Col>
          <Heading
            value="Signer"
            size=Heading.H4
            marginBottom=8
            weight=Heading.Regular
            color=theme.neutral_600
          />
          <AddressRender address=packet.signer />
        </Col>
      </Row>
      <IndexIBCUtils.ProofHeight proofHeight=packet.proofHeight />
      <Packet packet=packet.packet />
    </>
  }
}

module TimeoutOnClose = {
  @react.component
  let make = (~packet: MsgDecoder.TimeoutOnClose.t) => {
    let ({ThemeContext.theme: theme}, _) = React.useContext(ThemeContext.context)
    <>
      <Row>
        <Col>
          <Heading
            value="Signer"
            size=Heading.H4
            weight=Heading.Regular
            marginBottom=8
            color=theme.neutral_600
          />
          <AddressRender address=packet.signer />
        </Col>
      </Row>
      <IndexIBCUtils.ProofHeight proofHeight=packet.proofHeight />
      <Packet packet=packet.packet />
    </>
  }
}
