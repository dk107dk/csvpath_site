---
description: Trusted publishing using Azure blobs is really quite straightforward.
---

# Google Cloud Storage

This page is really just here to point to [the S3 instructions](aws-s3.md) because everything is basically the same.&#x20;

You need a `GCS_CREDENTIALS_PATH` environment variable. It points to the location of your service account JSON credentials file. Other than that, there's no additional setup — just use of gs`://` instead of `sftp://` or `s3://` in `config/config.ini` or when you add content with `FileManager` or `PathsManager`.&#x20;

Super easy!

<figure><img src="../../../.gitbook/assets/Screenshot 2025-03-06 at 2.04.03 PM.png" alt="A screenshot of the Azure Storage Explorer app showing CsvPath Framework CSV and JSON files"><figcaption></figcaption></figure>

