# Validation and Upgrading

Validation and upgrading is a core part of CsvPath Framework's mission. We're here to end garbage-in-garbage-out, at least in the data onboarding process. The Framework enables your validation and upgrading with CsvPath Validation Language. CsvPath Validation Language is a domain-specific validation language. It is purpose-built for evaluating if your data meets expectations, and if it doesn't, how to upgrade it.&#x20;

You write CsvPath Validation Lanaguage in csvpath statements or scripts. One or more csvpath statement lives in a file. Groups of csvpath statements are executed in runs. A group of csvpath statements is called a named-paths group.&#x20;

The Framework stores named-paths groups in a validation assets area. By default, that is ./inputs/named\_paths, but it can be any location you like in any system CsvPath Framework has a backend for. Currently the backends are:&#x20;

* Filesystem
* S3
* Azure
* GCS
* SFTP

As we saw [in an earlier page](../../the-three-data-spaces/validation-assets.md), a named-paths group is three files. One of those files is created by you, the csvpath(s). One is optionally created by you and the API working together, definition.json, that defines csvpath members of the group. And the third file is generated automatically, the `manifest.json` holding all the metadata about the named-paths group.

A csvpath looks like this:&#x20;

```
$[*][ print("hello world") ]
```

Briefly, this path scans every line of a CSV, Excel, or data frame and prints `hello world` once for every line. Obviously there's much more useful stuff you can do with CsvPath Validation Language! Regardless, to get this statement into a named-paths group called `hello-world`, put the statement in a file called `hello-world.csvpath` and then do:

```python
from csvpath import CsvPaths
CsvPath().paths_manager.add_named_paths(name="hello-world", file_name="./hello-world.csvpath")
```

Your file goes into the validation assets area like this:

<figure><img src="../../../../.gitbook/assets/Screenshot 2025-03-29 at 5.34.52 PM.png" alt=""><figcaption><p>I used the sensible default location, inputs/named_paths, but you can use any location</p></figcaption></figure>

Looking at manifest.json, you can see that there isn't much going on in this super simple example.&#x20;

<figure><img src="../../../../.gitbook/assets/Screenshot 2025-03-29 at 5.41.48 PM.png" alt=""><figcaption></figcaption></figure>

Notice that the manifest is an array. Each time you load your `hello-world` named-paths group CsvPath Framework adds a new entry with the updated information. Unlike in the source files staging area we don't keep versions of csvpaths — you have Git or another source management system for that. Instead we just capture the identifying information:&#x20;

* The SHA256 hash of the csvpaths in the group
* A UUID that is passed along in every named-path group run
* An array of the statements in the group

This information allows us to trace back to exactly what validation and upgrading was done to achieve a result dataset.&#x20;

As you can imagine, including all the csvpaths in the group at every manifest update has the potential to take a lot of space. Named-paths groups with tens to hundreds of csvpath statements are not uncommon. Nevertheless, we store and update the named-paths group frequently in development, but only rarely in production, so while the manifest may grow to a few kilobytes it is typically not huge. And since we only read the manifest at updates when we're tracking new information, as opposed to at named-path group run time,  performance is not a concern. &#x20;

Also note, if you configure CsvPath Framework to capture your updates to a database (today Sqlite, MySQL, or Postgres) the csvpath statements are not included — they only are copied into the manifest. That way you can query the database quickly without picking through potentially large numbers of csvpaths in the manifest, but turn to the manifest if you need to find the actual csvpaths loaded at a moment in time.
