# Export Data and Metadata

CsvPath Framework enables you to publish data to its immutable archive. That's its job. But the Framework also gives you options for pushing data to other locations and/or to site your archive in part of your data lake. The options are:&#x20;

* Configure individual csvpaths within named-paths runs to [push results files to an SFTP server](../../../how-tos/sending-results-by-sftp.md)
* Configure individual csvpaths within named-paths runs to [transfer results files to a local file system location or locally mounted remote share](../../../how-tos/transfer-a-file-out-of-csvpath.md)
* Publish all or any of the result files of an individual csvpath within a named-paths run [to a CKAN server](../../../how-tos/ckan/ckan-csvpath-setup.md)
* Site the whole archive on one of [the CsvPath Framework's backends](../../../how-tos/storage-backends/):&#x20;
  * AWS S3
  * Azure Blob Storage
  * Google Cloud Storage
  * SFTP
  * And, of course, the local filesystem or mounted share

And keep in mind, the CsvPath Framework's Archive is essentially a namespace. You can locate your archive anywhere. And you can run multiple archives to publish from multiple backends or in the same place, but under a different root directory.
