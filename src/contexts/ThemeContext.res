type t = {
  isDarkMode: bool,
  theme: Theme.t,
}

let keyword = "theme"
let context = React.createContext(ContextHelper.default)

let getThemeMode = () => {
  LocalStorage.getItem(keyword)
  |> Belt_Option.flatMap(_, local => {
    local == "dark" ? Some(Theme.Dark) : Some(Day)
  })
  |> Belt.Option.getWithDefault(_, Day)
}

let setThemeMode = x =>
  switch x {
  | Theme.Day => LocalStorage.setItem(keyword, "day")
  | Dark => LocalStorage.setItem(keyword, "dark")
  }

@react.component
let make = (~children) => {
  let (mode, setMode) = React.useState(_ => getThemeMode())

  let toggle = () =>
    setMode(prevMode =>
      switch prevMode {
      | Day =>
        setThemeMode(Dark)
        Dark
      | Dark =>
        setThemeMode(Day)
        Day
      }
    )

  let theme = React.useMemo1(() => Theme.get(mode), [mode])
  let data = {isDarkMode: mode == Dark, theme: theme}

  React.createElement(
    React.Context.provider(context),
    {"value": (data, toggle), "children": children},
  )
}