# Record Testing Mode

In Record mode, the test suite does not behave exactly as normal.  It's intention is to be used to establish: 

- the VCR cassettes used for mocked http requests,  
- a database state of the stellar-core database after applying a set of fixture transactions.

**NOTE**  Record mode assumes you have manually started up a new s ledger using the database defined in HAYASHI_DATABASE_URL.  We will eventually add a system to automatically manage this for you, but we have not yet implemented it yet.