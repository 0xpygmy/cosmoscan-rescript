```sh

# generate graphql_schema.json
npx get-graphql-schema https://graphql-lt6.bandchain.org/v1/graphql -j > graphql_schema.json

# installed the dependencies
yarn

## run the complier
yarn start

# (in another tab) Run the development server
RPC_URL=https://laozi-testnet6.bandchain.org/api GRAPHQL_URL=graphql-lt6.bandchain.org/v1/graphql LAMBDA_URL=https://asia-southeast1-testnet-instances.cloudfunctions.net/executer-cosmoscan GRPC=https://laozi-testnet6.bandchain.org/grpc-web FAUCET_URL=https://laozi-testnet6.bandchain.org/faucet yarn server
```
