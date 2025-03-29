# Trusted Publishing

<figure><img src="../../../.gitbook/assets/Screenshot 2025-03-28 at 12.23.39 PM.png" alt="" width="563"><figcaption><p>The trusted publishing area is the most flexible and content rich</p></figcaption></figure>

By default we refer to the trusted publishing space as the Archive. The Archive is the richest, most flexible, and most complex of the data file areas in CsvPath Framework.&#x20;

&#x20;The Archive can be named anything you like. It is a kind of namespace. In large DataOps groups or companies with many data partners we would recommend using multiple archives in order to make your data estate more manageable. If you use multiple trusted publishing archives they can live together in one backend system or be split over multiple systems of different types.

Within the Archive the first level is a list of named-results. A named-result takes the same name as the named-paths group that generated it. When you ask CsvPath Framework for the named-results using just the plain named-results name, it gives you the results from the most recent run.

Within a named-results directory you can have a set of run directories. (Sometimes we refer to these as runs, run\_dirs, or run homes). Alternatively, you can optionally define a directory structure within a named-results directory that helps you organize results according to how you want to access your data. The organization is defined using the template stored with the named-paths group. &#x20;

Within the template-defined organizational folder you come to a set of run\_dirs named with a datetime. The datestamp in the form `%Y-%m-%d_%H-%M-%S_nn`, where the optional `nn` is a number from `0` to `99` that disambiguates any runs that have the same datestamp. For example: `2025-02-28_14-32-59_0`.

Optionally, the named-results layout template can have one or more suffix directories below the run\_dir. These would only add value only if they help a downstream system better identify what data is available in the run without other downstream data consumers having to browse a larger directory structure above the run\_dir.&#x20;

Below the suffix directories, if any, are the individual csvpath results directories. (These are sometimes referred to as instance directories). There is one instance result directory for each csvpath in the named-paths group that generated the named-results. And collectively these instance directories hold the final output of the run.

CsvPath Framework generates up to seven common files for each csvpath instance. They are:

| File          | Purpose                                                                                                                                                     |
| ------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- |
| data.csv      | Holds the matched rows from the file being validated and/or upgraded                                                                                        |
| unmatched.csv | Contains rows that didn't match. These rows could be considered valid, invalid, or just extra, depending on how the run is setup.                           |
| vars.json     | CsvPath Framework allows you to set and use variables in your csvpath statements. These are somewhat similar to session variables in an application server. |
| meta.json     | Contains user-defined metadata, per-csvpath configuration settings, and runtime csvpath info.                                                               |
| errors.json   | A set of detailed error event dictionaries that give user-friendly error messages and developer-friendly data about any validation or csvpath errors.       |
| printouts.txt | Any number of user-defined print statement streams are collected in a multi-section output file.                                                            |
| manifest.json | CsvPath Framework-generated metadata about the run the results come from                                                                                    |

We will dig into these results outputs in many other parts of this documentation.
