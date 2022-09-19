type t = {
  address: string,
  amount: int,
}

let convert: t => 'a = %raw(`
function(data) {
  return {...data};
}
  `)

let request = (data: t) =>
  Axios.post(Env.faucet, convert(data))->Promise.then(response => {
    Promise.resolve(response)
  })
