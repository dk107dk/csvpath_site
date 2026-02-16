---
description: Trusted publishing using Azure blobs is really quite straightforward.
---

# Azure

This page is really just here to point to [the S3 instructions](aws-s3.md) because everything is basically the same.&#x20;

You need a `AZURE_STORAGE_CONNECTION_STRING` environment variable holding your storage account connection string. Other than that, there's no additional setup — just use of `azure://` instead of `sftp://` or `s3://` in `config/config.ini` or when you add content with `FileManager` or `PathsManager`.&#x20;

So easy!

<figure><img src="../../../.gitbook/assets/Screenshot 2025-03-05 at 6.46.22 PM.png" alt="A screenshot of the Azure Storage Explorer app showing CsvPath Framework CSV and JSON files"><figcaption></figcaption></figure>

