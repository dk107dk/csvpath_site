---
description: >-
  Stop writing custom data import and validation scripts. CsvPath automates
  CSV/Excel data ingestion and quality checks from vendor data partners. Open
  source Python.
cover: .gitbook/assets/Screenshot 2024-08-30 at 7.53.30 AM.png
coverY: 0
layout:
  width: default
  cover:
    visible: true
    size: full
  title:
    visible: false
  description:
    visible: false
  tableOfContents:
    visible: true
  outline:
    visible: false
  pagination:
    visible: true
  metadata:
    visible: true
---

# CsvPath - Automated CSV & Excel Ingestion and Validation for Data Engineers

<figure><img src=".gitbook/assets/logo-wordmark-200dpi-428x105.png" alt="Logo for the CsvPath Framework" width="321"><figcaption></figcaption></figure>

<h2 align="center">Automated Data Preboarding</h2>

### Stop Manual CSV & Excel Data Validation - Automate Partner File Processing

#### CsvPath is an open source framework that validates, cleans, and processes CSV/Excel files from data partners before they break your pipelines.

The open source [CsvPath Framework](https://github.com/csvpath/csvpath) **enables you to control data entering the enterprise** with less manual effort, fewer ingestion failures, and more agile development using a straightforward preboarding pattern.  &#x20;

<figure><img src=".gitbook/assets/Screenshot 2025-03-09 at 6.45.40 PM.png" alt="" width="375"><figcaption><p>Your data lake deserves a data publisher it can trust!</p></figcaption></figure>

{% file src=".gitbook/assets/CsvPath - Data Onboarding Simplified.pdf" %}

CSV and Excel validation is core to the Framework. **CsvPath Validation Language** is simple, easy to integrate, and flexible enough to handle the unexpected. Inspired by [Schematron](https://schematron.com/), [XPath](https://www.w3.org/TR/xpath-31/), and [the Collect, Store, Validate, Publish design pattern](broken-reference), CsvPath Validation Language brings powerful data validation to less structured data. Coming from the world of DDL, XSD, or JSON Schema? [Start here](topics/validation/schemas-or-rules.md).

<table data-view="cards"><thead><tr><th></th><th></th><th data-hidden data-card-cover data-type="files"></th><th data-hidden></th><th data-hidden data-type="content-ref"></th><th data-hidden data-card-target data-type="content-ref"></th></tr></thead><tbody><tr><td><a href="broken-reference"><strong>Getting Started</strong></a></td><td>5-minutes to get the idea</td><td><a href=".gitbook/assets/how_to_start3.png">how_to_start3.png</a></td><td></td><td><a href="getting-started/quickstart.md">quickstart.md</a></td><td></td></tr><tr><td><a href="getting-started/getting-started-with-csvpath-+-openlineage.md"><strong>CsvPath + OpenLineage</strong></a></td><td>Get started with Edge Governance</td><td><a href=".gitbook/assets/ol-close-up (1).png">ol-close-up (1).png</a></td><td></td><td><a href="getting-started/csv-and-excel-validation/your-first-validation.md">your-first-validation.md</a></td><td><a href="getting-started/getting-started-with-csvpath-+-openlineage.md">getting-started-with-csvpath-+-openlineage.md</a></td></tr><tr><td><a href="getting-started/integrations/getting-started-with-csvpath-+-ckan.md"><strong>Easy dataset publishing to the leading data portal</strong></a></td><td></td><td><a href=".gitbook/assets/csvpath_plus_ckan-v2g (2).png">csvpath_plus_ckan-v2g (2).png</a></td><td></td><td></td><td></td></tr></tbody></table>

The **CsvPath Framework** implements the [**Collect, Store, Validate Publish architectural pattern.** ](https://static1.squarespace.com/static/66df9d47982d0d40e1574327/t/6771fe6f63bbf5361725ad05/1735523953587/The+Collect+Store+Validate+Pattern+-+Atesta+Analytics.pdf)Data preboarding goes faster, is more cost-efficient, and more effective using a proven architecture. Why roll your own preboarding solution when there is a purpose-built option?

Out-of-the-box, CsvPath Framework is built to fill the blindspot between MFT (managed file transfer) and the data lake with a simple path to provably correct data.

This data onboarding blindspot is a big deal. Think about it. If even 1 in 30 companies depends heavily on CSV or Excel data, the _lack of **delimited file pre-boarding is a trillion-dollar problem**_. In our experience, 1 in 30 would be a low estimate.&#x20;

<figure><img src=".gitbook/assets/data-flow.png" alt="A data flow diagram showing how CSV, Excel and other tabular data come into the organization through a preboarding process that acts as a Trusted Publisher to the data lake and applications."><figcaption></figcaption></figure>

### Introducing FlightPath, the frontend to CsvPath Framework

[**FlightPath** is a powerful new frontend to CsvPath Framework](https://www.flightpathdata.com/). Go beyond the Framework's built-in CLI. Get up and running faster with a purpose-built preboarding development and operations console. And FlightPath gives you all the help and examples you need move quickly. Available as a _free_ download from the [Microsoft Store](https://apps.microsoft.com/detail/9p9pbpkz4jdf?hl=en-US\&gl=US) and the [Apple MacOS Store](https://apps.apple.com/us/app/flightpath-data/id6745823097).

<figure><img src=".gitbook/assets/flightpath-logo-1-sm.png" alt=""><figcaption></figcaption></figure>

Together CsvPath Framework and FlightPath Data can help you build leadership's confidence that your data governance doesn't turn a blind eye to your most unruly data.&#x20;



<figure><img src=".gitbook/assets/integration_logos (8).png" alt="Logos of the many popular DataOps tools that are integrated with CsvPath Framework: aws s3, azure, slack, Excel, opentelemetry, sftp, ckan, pandas, openlineage, and more" width="563"><figcaption><p>CsvPath has a bunch of built-in integrations. Suggest more!</p></figcaption></figure>

{% hint style="success" %}
For more background on preboarding and the CsvPath and FlightPath architecture [check out the CsvPath blog](https://blog.csvpath.org/).&#x20;
{% endhint %}



{% embed url="https://github.com/csvpath/csvpath" %}
