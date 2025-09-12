# The Three Data Spaces

<figure><img src="../../../.gitbook/assets/Screenshot 2025-03-28 at 11.07.34 AM.png" alt="" width="563"><figcaption><p>CsvPath Framework keeps files in three areas</p></figcaption></figure>

CsvPath Framework is file-based. Files come in and are staged. Validation and upgrading scripts are written and loaded. The scripts are applied to data files and the resulting data files are published.&#x20;

Each of these areas can live in a different backend. CsvPath Framework supports:

* Filesystems
* SFTP&#x20;
* AWS S3
* Azure Blob Storage
* Google Cloud Storage
