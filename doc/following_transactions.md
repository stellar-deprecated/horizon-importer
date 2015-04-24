# Following Transactions On An Account

Let's describe a normal scenario for a gateway:  The gateway will have a central account into which their user's will send credits such that the user can later withdraw physical money from the gateway.  To facilitate this, the gateway will run an application that watches their gateway account for transactions in which it is a participant.  Each time the application detects a new transaction, it will interpret the results and perhaps update an internal database to reflect the deposit from the Stellar Network.

## Process Overview

The horizon api is RESTful; That is, different urls represents different resources.  For example, the `/transactions` url is the resource that is a collection of all transactions that have been committed to the ledger, `/accounts/guyXJFahhW91LRV278LQpusMKBbifrA81W9zyYpB1LPE457qX7` is the resource that is the summary of the account with the address "guyXJFahhW91LRV278LQpusMKBbifrA81W9zyYpB1LPE457qX7".

For this overview, let's assume the gateway's account is at the address "guyXJFahhW91LRV278LQpusMKBbifrA81W9zyYpB1LPE457qX7".
The resource we are concerned about for this scenario is `/accounts/guyXJFahhW91LRV278LQpusMKBbifrA81W9zyYpB1LPE457qX7/transactions`, which represents "All transactions in which the account has participated".  This resource is a paged collection of transactions, ordered chronologically (older transactions first).  By watching this resource we can know all transactions that apply to the gateway account.

Unfortunately, it's not possible to simply load all transactions that apply to a given account.  Overtime the list will grow and it simply is not feasible to load 10,000 transactions in a single HTTP request.  For that reason, you must _page_ through the transaction collection.  Horizon uses what is known as a "token-based paging system".  When you request a page of data from horizon, you supply an "after" parameter which signifies the last record you saw (or nothing if you want to start at the beginning of a collection) and a "limit" parameter which specifies how many records at most you want on this request.

Horizon makes this process easier because every response from horizon contains a set of links that give you the ability to navigate to new data, just like a browser can navigate from webpage to webpage.  Lets look at an example response from the `/transactions` resource:

```json
{
  "_links": {
    "next": {
      "href": "/transactions?after=373a31&limit=10&order=asc"
    },
    "self": {
      "href": "/transactions"
    }
  },
  "_embedded": {
    "records": [...]
  }
}
```

Notice the "next" link with the "_links" object?  Following that link will give you the next page of results.  By continually following the next link, we can eventually load all transactions for a given account.  In fact, the system is designed in such a way that even when no you have loaded all the available data, you can simply continue to follow the next link from every response to load new transactions as they occur.

TODO: describe SSE and how "Last-Event-ID" overrides the "after" parameter

## Following transactions via polling

1.  Request `/accounts/guyXJFahhW91LRV278LQpusMKBbifrA81W9zyYpB1LPE457qX7/transactions` to retrieve the first page of transactions for the account.
2.  Process the results
3.  Save the "next" link from the "_links" section of the response
4.  Request the saved "next" link.
5.  Process the results
6.  Save the "next" link from the "_links" section of the response
7.  Sleep for some time
8.  Goto step 4


## Following transactions via Server-Sent-Events (SSE)

TODO
