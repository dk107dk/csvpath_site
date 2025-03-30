# Export Data

CsvPath Framework enables you to publish data to an immutable archive. That's its job. But it also gives you options for pushing data to other locations and/or to site your archive in one part of your data lake. The options are:&#x20;

* Configure individual csvpaths within named-paths runs to [push results files to an SFTP server](../../../how-tos/sending-results-by-sftp.md)
* Configure individual csvpaths within named-paths runs to [transfer results files to a local file system location or locally mounted remote share](../../../how-tos/transfer-a-file-out-of-csvpath.md)
* Publish all or any of the result files of an individual csvpath within a named-paths run [to a CKAN server](../../../how-tos/sending-results-to-ckan.md)
* Site the whole archive on one of [the CsvPath Framework's backends](../../../how-tos/storage-backend-how-tos/):&#x20;
  * AWS S3
  * Azure Blob Storage
  * Google Cloud Storage
  * SFTP
  * And, of course, the local filesystem or mounted share
