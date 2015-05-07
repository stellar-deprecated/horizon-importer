# The StellarCore Models

This directory contains the models that interface with the stellar core-managed
database.  

Presently, these models are all marked as read_only, since stellar core should
be the only process writing to these tables.

See `StellarCore::Base` for common facilities shared by all StellarCore models.