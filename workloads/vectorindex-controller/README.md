== VectorIndex Controller ==

A simple controller for `vectorindices.new.artificialwisdom.cloud` custom objects.

This controller builds indices by loading Feather tables from OCI.

A Dockerfile is included for convenience.

=== Phases ===

The phases are:

* AwaitingDataSet: The corresponding `DataSet` object is not yet `Ready`.
* BuildingIndex: The index is being constructed.
