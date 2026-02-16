---
description: You have a few simple choices for where to store your assets
---

# Storage Backends

CsvPath Framework stores data and csvpath files in three locations that it manages for you:

* The archive &#x20;
* Data files &#x20;
* Csvpath files&#x20;

These locations are settable in `config/config.ini`. By default the archive is at `./archive`. The defaults for data files and csvpath files are `./inputs/named_files` and `./inputs/named_paths`, respectively.

<figure><img src="../../../.gitbook/assets/Screenshot 2025-02-20 at 5.07.37 PM.png" alt="" width="563"><figcaption></figcaption></figure>

You can set these three areas to point to locations in four types of storage. (With more options on the way!)

* The local filesystem
* AWS S3
* An SFTP server
* Azure Blob Storage
* Google Cloud Storage

There are [more how-to notes here](../../how-tos/storage-backend-how-tos/). The screenshot above kind of gives away the how-to secrets, tho. First, let's revisit what the locations are and how they work.

## The Archive

The archive serves two purposes:&#x20;

* It is a namespace that allows separate CsvPath Framework projects to group their data publishing or separate their data. You can name a CsvPath project's archive anything you like.
* It is the [trusted publisher](../../glossary.md), an _immutable and idempotent_ archive of known-good and known-bad data, serving downstream data consumers

The archive is organized in a hierarchy like this:&#x20;

<figure><img src="../../../.gitbook/assets/Screenshot 2025-02-20 at 4.00.16 PM.png" alt="" width="375"><figcaption></figcaption></figure>

All your results go to the archive. The metadata collected characterizes the data and its processing completely, so you can easily tell if a set of results are known-good or known-bad. Either way, you have a complete record for the purposes of traceability and explainability. Also, keep in mind that the archive can be a data source for csvpaths that are unrelated to the process of creating it.&#x20;

## Named-files Inputs

Named-files are the untrustable source data that the CsvPath Framework identifies, validates, upgrades, and stages in the archive for downstream use. Named files are one-name, one-file — unlike named-paths where the name is applied to a group of csvpaths. Why is it useful to name a file? There are several advantages:&#x20;

* A name represents a changing data stream, allowing a process to address new data in a uniform way over time
* Less important, but a factor: names can be shorter and more memorable than a complete file path

The first bullet has three aspects:&#x20;

* Changing versions
* Changing file names
* Serialized data delivery

CsvPath Framework versions your input data files. What it does is simpler than Git and other version control systems. CsvPath just stores data immutably and adds a new file when it gets new bytes. The structure is:&#x20;

<figure><img src="../../../.gitbook/assets/Screenshot 2025-02-20 at 4.29.43 PM.png" alt="" width="375"><figcaption></figcaption></figure>

You can imagine a company that receives orders files having an `orders` named-file tree that looks like this:&#x20;

<figure><img src="../../../.gitbook/assets/Screenshot 2025-02-20 at 4.37.49 PM.png" alt=""><figcaption></figcaption></figure>

You can see all three of the ways CsvPath Framework expects named-file data to change. First, there is a progression in time from left to right: march, april, may. Second, in `april-2025.csv` you can see two versions of the data with at least one byte's difference between them. And third, in May the company changed how it names files and seems to have begun breaking the dataset down by region. As each of these files arrives (the lowest level boxes represent the actual data files — `april-2025.csv` is actually a directory within CsvPath's files tree) it is handled as the `orders` file. As the current `orders` file it has the same csvpaths applied to it in exactly the same way. &#x20;

## Named-paths Inputs

Named-paths live in a similar directory structure to data files. Each named-paths name identifies some number of csvpaths that are run against data files as a group. Having csvpaths in groups has several advantages:&#x20;

* Validations, canonicalization, and upgrading can be broken down into small testable and composable steps
* We can turn individual csvpaths on and off, or make a number of other settings, so that each csvpath can run with the settings that serve a specific purpose.
* The data results can be separated out, chained into flows, or reused by other csvpaths using references

&#x20;The first bullet is the big one. Imagine a data analyst that has to check data against a defense acquisition CSV or Excel validation standard running to hundreds of pages. Yes, that's a thing. They might not put all their validations in one named-paths group, but you can imagine a named-paths group where each csvpath validated data against one rule. There could easily be hundreds of csvpaths in that one group. Sounds terrible, right?  But imagine trying to validate using one csvpath for hundreds of rules. That would be much so much worse in every way!

## Picking your location

Now, for all that, the actual thing we want to do here — choose and configure where we put our files — turns out to be super easy. Open your config/config.ini file. You should see a `[results]` section and an `[inputs]` section. With in `[results]` there is an archive key. It takes a path to your archive. And within `[results]` there is a file key and a csvpaths key. Those point to your file inputs. Use relative or fully qualified file system paths. For Azure, S3, GCP, and SFTP use URI form locations like:&#x20;

* `s3://csvpath-example-1/named_files`
* `sftp://my-server/csvpath/archive`
* `azure://csvpath/storage/named_paths`
* `gs://csvpath_def/trusted_publisher_archive`

<figure><img src="../../../.gitbook/assets/Screenshot 2025-02-20 at 5.07.37 PM.png" alt="" width="563"><figcaption></figcaption></figure>

Each of these three `config.ini` keys can point to a different backend. You can mix and match the filesystem, S3, SFTP, the file system, Google, and Azure any way you like. The only constraint is the additional latency of moving storage from the local hard disk to a remote backend. Test to make sure you're good with the latency, given your use case. If you need to, consider moving your compute closer to your storage. For e.g., you could choose to put CsvPath Framework into an AWS Lambda or a Fargate container.

Over time, CsvPath Framework will probably support more backends. For many use cases the network storage options you have already today are super easy and effective. Give them a try!
