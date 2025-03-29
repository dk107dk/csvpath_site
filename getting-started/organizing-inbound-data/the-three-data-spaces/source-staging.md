# Source Staging

<figure><img src="../../../.gitbook/assets/Screenshot 2025-03-28 at 2.19.56 PM.png" alt="" width="563"><figcaption><p>The source staging area is for named versions of raw inbound files</p></figcaption></figure>

CsvPath Framework collects all inbound files into a staging area. This area is intended to be:&#x20;

* A permanent of immutable versions of distinct inbound files
* The sources used by the validation and upgrading engine
* Available for inspection by individuals triaging downstream problems
* Accessible by any systems that don't want the validation, upgrading, and metadata that CsvPaths runs offer. _(We anticipate the number of such ambivalent systems is approximately 0, but the access to raw source files is available)_

The source staging area can mirror any current directory layout. The "Path to file" box in the diagram above represents any file system structure you like. The structure is defined on a named-file by named-file basis using a template. We cover templates later in this documentation.

The "File name (as a directory)" box is just what it says: a directory named for a source file. E.g. if an inbound raw source file is named `2025-apr-01-sales-emea.csv`, it lives in a directory named `2025-apr-01-sales-emea.csv`.&#x20;

The actual file's bytes live in files named by SHA256 hash values. These hash fingerprints are unique to the exact content of a version of the file. If a new copy of `2025-apr-01-sales-emea.csv` arrives a day later with 1 character different from the original file, CsvPath Framework stores the new version in a file named by the new unique hash of the new content.

The named-file name is an abstract name like `orders` or `EMEA-orders` or `Q2-orders-Acme-EMEA`. It is whatever you like. The path within the named-file is constructed according to a template that is based on the path where MFT received the file. That means there can be multiple paths within the named-file name. Likewise, the name of the data file is likely to change. CsvPath Framework captures the new name and its new hash fingerprinted content.&#x20;

The abstract named-file name can be used stand-alone. When you do that, CsvPath assumes you mean the most recent file that was registered with that name.&#x20;

Alternatively you can refer to a named-file name with the full path to the filename. You can also use a partial path to find one or more files. A partial path can have pointers to dynamically find a version of one or more files registered with the named-file name at a location and/or within an arrival window.&#x20;

We will explain how this flexibility works and is helpful in a later section of these docs.

Finally, the named-file directory contains a manifest.json that tracks arrival times, identities, and other automatically generated metadata.
