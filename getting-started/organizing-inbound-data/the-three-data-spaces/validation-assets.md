# Validation Assets

<figure><img src="../../../.gitbook/assets/Screenshot 2025-03-28 at 11.47.47 AM.png" alt="" width="375"><figcaption><p>CsvPath Framework keeps validation assets in a shallow directory tree</p></figcaption></figure>

CsvPath Framework has delimited data validation and upgrading as a core feature.  CsvPath Validation Language statements are like SQL queries, XQuery statements or XPath paths. A Validation Language statement is called a csvpath.&#x20;

The Framework enables you to apply multiple csvpaths to one or more source files in a run as a unit. Using multiple csvpaths in the same run allows you to decompose your validation and upgrading steps for easier development and testing, as well as to separate each csvpath's metadata and documentation for clarity. If your CSV or Excel file validation and upgrading requirements have 10, 20, 50 or 100 rules, being able to separate the rules for development and testing, while running them in production as a unit, is very helpful.&#x20;

The validation assets area is relatively flat. It is a directory containing a folder for each named-paths group. Each named-paths group directory contains a `group.csvpaths` file and a `manifest.json`. It may also include a `definition.json` file. These files are for:&#x20;

* `group.csvpaths` holds all the csvpath statements in the named-paths group. (You can keep the statements in separate files for development. When you load multiple csvpaths into a named-group CsvPath Framework automatically compiles them into a single group.csvpaths file)
* `manifest.json` holds metadata collected by CsvPath Framework about your named-paths group and its csvpath statements
* `definitions.json` is optionally created by the csvpath writer. It contains a JSON structure that defines the order of the csvpaths and their original locations. (They can be anywhere reachable by the CsvPath Framework process). It also holds configuration options for the named-paths group — most especially, a template defining the archive location of the results files

CsvPath Framework does not keep versions of named-paths groups like it does named-files. The reason for this is that we anticipate that most developers will have their code, including csvpaths, in a source code revision control system like Git. CsvPath Framework does not try to do Git's job.
