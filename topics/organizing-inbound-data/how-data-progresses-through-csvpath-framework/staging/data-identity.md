# Data Identity

Raw source files are staged by registering them with CsvPath Framework. Registration happens using the Framework's API or [the CLI](../../../the-cli.md).  When a file is registered a golden master copy is created which becomes the canonical file for that file in its raw form. In this way, CsvPath Framework becomes the source of truth and identity for data files entering the organization.&#x20;

From the point a file is registered to the point it is published the data's identity is tracked using:

* The time of registration
* The bytes' SHA256 hash
* A UUID
* The location of the source file&#x20;

<figure><img src="../../../../.gitbook/assets/Screenshot 2025-03-28 at 2.47.20 PM.png" alt=""><figcaption><p>CsvPath Framework captures file registration metadata within each named-file</p></figcaption></figure>

Think of these four things as if they were the data's

* Birth date
* Given and family names
* Social Security number
* Town and state of residence

These four elements of identity are tracking two things: 1.) the immutable file and 2.) the bytes sourced from the file as it moves through CsvPath Framework. In the Framework data is never overwritten. A named-file name may include source files with various names from various locations. The named-file may have a template that allows source files to be stored in a dynamically defined folder tree. Regardless of all this potential for variation within the named-file, the identity of each version of a named-file's registered files is carried forward unchanged and fully traceable.&#x20;

