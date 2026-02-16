# The storage backends

[As described here](../../organizing-inbound-data/the-three-data-spaces/), CsvPath Framework stores files in three protected spaces:&#x20;

* Source file staging (a.k.a. the named-files area)
* The csvpaths area (a.k.a. the named-paths area)
* The archive

Each of these areas can live in any of the five supported backends:&#x20;

* File system
* [SFTP](loading-files-from-s3-sftp-or-azure.md)
* [AWS S3](store-source-data-and-or-named-paths-and-or-the-archive-in-aws-s3.md)
* [Azure](store-source-data-and-or-named-paths-and-or-the-archive-in-azure.md)
* [Google Cloud Storage](store-source-data-and-or-named-paths-and-or-the-archive-in-google-cloud-storage.md)

CsvPath Framework generates events during staging named-files, loading named-paths, and running named-paths groups against named-files to populate the archive. Events are stored in the file backends as `manifest.json` files. In addition to your main file backend options, you can also choose to store events in a [SQL database](../send-events-to-mysql-or-postgres.md) and/or send them to an observability system that supports [OpenTelemetry](../../../getting-started/dataops-integrations/opentelemetry.md) or [OpenLineage](../../../getting-started/dataops-integrations/openlineage.md).&#x20;



