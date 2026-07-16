---
description: Sending result data where you need it.
---

# Transfers

CsvPath Framework attempts to fit seamlessly into the systems and workflows you already use. There are three main tools to achieve a level of transparencies to other, pre-existing systems:&#x20;

* Templates — the way to structure your staged and results files areas&#x20;
* Activations — linking file registrations to named-paths group runs
* Transfers — putting result files exactly where collaborating systems expect them

Transfers are instructions for CsvPath Framework to move results files to other locations in any of the backends supported, including arbitrary SFTP servers that are not configured as Framework backends.

There are three types of files that can be moved:

* Any standard result file
* Any printouts or Parquet files, regardless of the name
* The registered source data file that was used in the run

There are two ways to set up transfers:&#x20;

* &#x20;Transfer mode (a `transfer-mode:` directive in a csvpath's leading comment)
* In the named-paths group's `definition.json` file

Transfer mode is more limited, but it can be configured by the csvpath writer on a csvpath-by-csvpath basis. That is a powerful feature, since a csvpath writer may not control when their csvpaths are deployed to production. It may also be helpful when composing small csvpaths into larger rule sets, as we advocate you do for better testing.

Defining transfers at the named-paths group gives you a bit more. There, you can set transfers to run only when a status is met. We use the same statuses with transfers that we use elsewhere:&#x20;

* All runs
* Valid runs
* Invalid runs
* Runs with errors

As usual, remember that a valid run can have errors and an invalid run may have no errors. Errors and validity are separate concepts in CsvPath Framework for good reasons covered elsewhere.

#### The Configuration Is Simple, Really!

While the `definition.json` file has increasingly many capabilities, and despite transfers being a flexible feature, the configuration is relatively simple. The overall look of the file follows this example:

```json
{
  "maths": [],
  "_config": {
    "groups": {
      "maths": {
        "transfers": {
          "path_transfers": {
            "hello world": {
              "on_complete_all": [
                {
                  "file": "data",
                  "transfer_to": "foo"
                }
              ],
              "on_complete_invalid": [],
              "on_complete_valid": [],
              "on_complete_error": []
            },
            "minus and subtract": {
              "on_complete_all": [
                {
                  "file": "printouts",
                  "transfer_to": "bar"
                }
              ],
              "on_complete_invalid": [],
              "on_complete_valid": [],
              "on_complete_error": []
            }
          }
        }
      }
    }
  }
}
```

Here you can see that we're sending the standard `data.csv` and `printouts.txt` files to the value of variables generated in the csvpaths, `foo` and `bar`. The equivalent transfer mode would be:&#x20;

```
~ 
    transfer-mode: data > foo 
~
```

However, with transfer mode we don't have the run state option. We also don't have a consolidated and consistent transfers definition, as we do in `definition.json`.

So, how is that easy?

The answer is, use FlightPath Data to create your transfers. There is a transfers setup form that truly simplifies things. To find it, first load a named-paths group using the context menu in the project tree on the left. Right-click your `.csvpaths` file or a directory containing csvpaths and click the `Load csvpaths` item.&#x20;

Then, once you created the named-paths group, right-click on it in the right-hand middle window and select `Set transfers`.&#x20;

<figure><img src="../../../.gitbook/assets/Screenshot 2026-07-16 at 3.34.02 PM.png" alt="" width="375"><figcaption></figcaption></figure>

The transfers dialog opens showing the four run end-states on the left and the transfers for each on the right. Below the list of transfers is a form providing the csvpaths available, the files available (which you can edit to input arbitrarily named files), and csvpath variable that contains the transfer path.

<figure><img src="../../../.gitbook/assets/Screenshot 2026-07-16 at 3.32.03 PM.png" alt="" width="563"><figcaption></figcaption></figure>

When you click the Set button your data will be transfered to the definition.json file, eliminating the need to write deeply nested JSON.

Transfer paths are the same as the paths you use to configure backends. I.e. you can have:&#x20;

* Filesystem paths
* `s3://` for AWS S3
* `azure://` for Azure Blob Storage
* `gs://` for Google Cloud Storage
* `sftp://` for SFTP

S3, Azure, and GCS rely on your backend-configured accounts.&#x20;

SFTP is more interesting. As usual, we match on the server address and port configured in the Config > Integrations > SFTP form. But if we don't have a match there, we look in the named-paths group's definition.json for any SFTP servers that are configured there specifically for transfers. To set those up, right-click your named-paths group and select `Set SFTP sources`.&#x20;

<figure><img src="../../../.gitbook/assets/Screenshot 2026-07-16 at 3.33.30 PM.png" alt="" width="292"><figcaption></figcaption></figure>

As with `transfer-mode:`, we use variables, rather than hard-coded paths. This lets the csvpath writer, or the data source, determine where the files land. And that brings us back to the top. Why do we transfer, when we have a versioned, immutable results repository with a REST API access?&#x20;

The main reason to transfer is because most companies have a pre-existing file handling solution. It may not be the ideal solution — else why would you be looking at CsvPath Framework? — but the components of the solution are looking for files in a certain place, so it would be nice if they found them there. Moreover, pushing result files to a mutable working directory location helps further separate CsvPath Framework's Archive from day-to-day file wrangling.

