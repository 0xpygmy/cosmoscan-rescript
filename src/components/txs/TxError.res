module Styles = {
  open CssJs

  let errorContainer = (theme: Theme.t) =>
    style(. [
      padding(#px(10)),
      color(theme.failColor),
      backgroundColor(theme.mainBg),
      border(#px(1), #solid, theme.failColor),
      borderRadius(#px(4)),
      marginBottom(#px(24)),
      selector("> i", [marginRight(#px(8))]),
    ])
}

type log_t = {message: string}

type err_t = {log: option<string>}

let decodeLog = json => {
  open JsonUtils.Decode
  json->mustDecode(field("message", string))
}

let decode = json => {
  open JsonUtils.Decode
  json->mustDecode(option(field("log", string)))
}

// let parseErr = msg => {
//   let err =
//     msg
//     ->Json.parse
//     ->Belt.Result.flatMap(json =>
//       json
//       ->Js.Json.decodeArray
//       ->Belt.Option.flatMap(x =>
//         x
//         ->Belt.Array.get(0)
//         ->Belt.Option.flatMap(
//           y =>
//             y
//             ->decode
//             ->Belt.Option.flatMap(
//               logStr => {
//                 Some(
//                   logStr
//                   ->Json.parse
//                   ->Belt.Result.flatMap(logJson => Ok(logJson->decodeLog))
//                   ->Belt.Result.getExn,
//                 )
//               },
//             ),
//         )
//       )
//     )
//     ->Belt.Result.getWithDefault(msg)

//   "Error: " ++ err
// }

let parseErr = msg => msg

module Full = {
  @react.component
  let make = (~msg) => {
    let ({ThemeContext.theme: theme}, _) = React.useContext(ThemeContext.context)

    <div
      className={Css.merge(list{
        Styles.errorContainer(theme),
        CssHelper.flexBox(~wrap=#nowrap, ()),
      })}>
      <Icon name="fal fa-exclamation-circle" size=14 color=theme.failColor />
      <Text
        value={msg->parseErr}
        size=Text.Lg
        spacing=Text.Em(0.02)
        breakAll=true
        color=theme.textPrimary
      />
    </div>
  }
}

module Mini = {
  @react.component
  let make = (~msg) => {
    let ({ThemeContext.theme: theme}, _) = React.useContext(ThemeContext.context)

    <Text value={msg->parseErr} code=true size=Text.Sm breakAll=true color=theme.failColor />
  }
}
