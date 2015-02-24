# Record Testing Mode

In Record mode, the test suite does not behave exactly as normal.  It's intention is to be used to establish: 

- the VCR cassettes used for mocked http requests,  
- a database state of the hayashi core database after applying a set of fixture transactions. 