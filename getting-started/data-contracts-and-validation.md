---
description: >-
  Write schemas, data contracts, and validation rules in the language of your
  choice
---

# Data Contracts and Validation

There is no one-size-fits-all validation language. CsvPath Framework strives to support all common edge data formats at the ingress point.&#x20;

Today, the following validation languages and formats are supported:

* [**JSON Schema**](https://json-schema.org/): JSON, including lists of JSON documents - [start here](../topics/how-tos/validating-json/).
* [**ODCS**](https://bitol-io.github.io/open-data-contract-standard/v3.1.0/) (Open Data Contract Standard): tabular data - [start here](../topics/how-tos/validating-with-odcs.md).
* [**XSD**](https://www.w3.org/TR/?filter-tr-name=xml+schema+definition) (XML Schema Definition): XML - [start here](../topics/how-tos/validating-xml/validating-xml-using-xsd.md).
* [**CsvPath Validation Language**](https://github.com/csvpath/csvpath/tree/main): tabular data and JSONL/NDJSON - [start here](../topics/how-tos/validating-csv-and-excel/).
* [**Pandas DataFrames**](https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.html): tabular data in data frames&#x20;
* [**XPath**](https://www.w3.org/TR/xpath/) **and** [**JSONPath**](https://www.rfc-editor.org/info/rfc9535/): supporting [Schematron](https://www.schematron.com/)-like rules-based validation over JSONL and XML
* [**Parquet**](https://parquet.apache.org/docs/): output of Parquet files based on `parquet()` schema function structures

{% hint style="info" %}
CsvPath Validation Language and ODCS support CSV, JSONL, Excel, and DataFrames as tabular data using the CsvPath Validation Language engine. The engine also provides the scaffolding for XSD and JSON Schema validation, as well as a limited integration with SQL. Note that CsvPath Validation Language supports both rules- and schemas-based validation over tabular. It also generates Parquet schemas, but delivers them only in the form of Parquet output files.
{% endhint %}

EDI, fixed-width, natural language entity recognition, and SodaCL remain on the backlog pending a groundswell of requests.&#x20;

Further SQL support is naturally higher on the list. However, at this time CsvPath Framework does not plan to widen it's role beyond acting as an edge data governance data firewall defending the ingress point. Adding data quality monitoring across the core database data estate is an interesting possibility, but other tools do that well. ETL/ELT functionality is firmly off the menu. The Framework is laser-focused on filling today's biggest blindspot in protecting and observing the data estate: the edge.
