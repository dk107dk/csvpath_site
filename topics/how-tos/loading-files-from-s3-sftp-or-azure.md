# Loading files from S3, SFTP, or Azure

Say you want to add a file currently sitting in S3 to CsvPath Framework as a named-file. That is to say, you want to give an easy name to a physical file and move it into CsvPath's inputs location from the bucket where it currently is in S3.

CsvPath Framework stores incoming files in the named-files directory tree. This is your data file registry. The location of the named-files directory is set in config/config.ini's `[inputs]` section under the `files` key. The named-files directories can live in any of the CsvPath storage backends. At this time those are:

* The local filesystem
* S3
* SFTP
* Azure Blob Storage

The file you want to register is also in one of these storage systems. How can you get it loaded into named-files? Easy, just use:

* A relative or absolute path to the file in the local system, or
* A URL like `s3://bucket/name`, or
* An `sftp://server:port/path/to/my/file` URL, or
* A URL like `azure://container/key`

In the case of S3 and SFTP you also need credentials. That will require one of these options:&#x20;

* For AWS, add an `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` pair to the environment
* For SFTP, credentials are set in the `[sftp]` section's `username` and `password` keys. Use all caps to reference environment variables.

<figure><img src="../../.gitbook/assets/Screenshot 2025-02-25 at 4.50.47 PM.png" alt="Moving csv or excel files into CsvPath Framework from S3 to SFTP"><figcaption><p>This is just an example. You can mix and match storage backends as you like. </p></figcaption></figure>

That takes care of the left-hand side of this picture. As you may already know, the right-hand side is setup simply using the `[inputs]` section and the `flies` and `csvpaths` keys. You can [read more about that here](store-source-data-and-or-named-paths-and-or-the-archive-in-aws-s3.md).
