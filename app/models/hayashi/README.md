# The Hayashi Models

This directory contains the models that interface with the hayashi core-managed
database.  

Presently, these models are all marked as read_only, since hayashi core should
be the only process writing to these tables.

See `Hayashi::Base` for common facilities shared by all Hayashi models.