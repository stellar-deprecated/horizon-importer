# Horizon

*NOTE: Horizon is in very active development*

Horizon is the client facing API server for the Stellar network ecosystem.  See [an overview of the Stellar ecosystem](TODO) for more details.

Horizon provides (well, intends to provide when complete) two significant portions of functionality:  The Transactions API and the History API.

## Transactions API

The Transactions API exists to help you make transactions against the stellar network.  It provides ways to help you create valid transactions, such as providing an account's sequence number or latest known balances. 

In addition to the read endpoints, the Transactions API also provides the endpoint to submit transactions.

### Future additions

The current capabilities of the Transactions API does not represent what will be available at the official launch of the new Stellar network.  Notable additions to come:

- Endpoints to read the current state of a given order book or books to aid in creating offer transactions
- Endpoints to calculate suitable paths for a payments

## History API

The History API provides endpoints for retrieving data about what has happened in the past on the stellar network.  It provides (or will provide) a endpoints that let you:

- Retrieve transaction details
- Load transactions that effect a given account
- Load payment history for an account
- Load trade history for a given order book


### Future additions

The history API is pretty sparse at present.  Presently you can page through all transactions in application order, or page through transactions that a apply to a single account.  This is really only useful for explaining how paging and filtering works within horizon, as most useful information for transactions are related to their operations.
