# Horizon Importer

[![Build Status](https://travis-ci.org/stellar/horizon-importer.svg)](https://travis-ci.org/stellar/horizon-importer)
[![Code Climate](https://codeclimate.com/github/stellar/horizon-importer/badges/gpa.svg)](https://codeclimate.com/github/stellar/horizon-importer)

Horizon Importer imports transaction data into a history database on behalf of the [Horizon API Server](http://github.com/stellar/horizon).  

Originally, horizon was written in ruby before it was decided to port it to go.  This project is the remnants of that original ruby codebase, and until the go port is complete, this project still handles:

- Importing stellar network data into a history database to allow more easy access
- Relaying transactions to the stellar network on behalf of the clients.

*The Horizon project (the go port at http://github.com/stellar/go-horizon) will eventually completely replace this project.*

## Status

- History importer is mostly complete and working.  See (/app/jobs/history/ledger_importer_job.rb) for any TODOs
- Transaction submission does not yet block while waiting for consensus on the submitted transaction, and polling is required to check submission status.

## Related documents

- See [doc/developing.md](doc/developing.md) for details on how to setup a development environment for working on horizon importer.

## Contributing

Please [see CONTRIBUTING.md for details](CONTRIBUTING.md).
