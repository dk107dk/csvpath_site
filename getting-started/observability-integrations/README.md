---
description: >-
  CsvPath offers built-in standards-based integrations for lineage, data
  observability, and alerting
---

# Observability Integrations

<figure><img src="../../.gitbook/assets/lootel.png" alt="" width="563"><figcaption></figcaption></figure>

These pages are about integrating CsvPath into your wider DataOps environment through observability integrations. The Framework supports data observability through OpenLineage and OpenTelemetry.

**OpenLineage**

* OpenLineage support: v2-0-2.&#x20;
* Framework handlers supported: `files`, `csvpaths`, `results` , `result` .
* Interoperability tested: Marquez, DataHub, DataDog, with other limited tests.
* As well as the primary data inputs and outputs, covers all result files and transfers.
* v2 is now the default. v1 remains available, providing baseline coverage tested on Marquez.

**OpenTelemetry**

* OpenTelemetry support: v1.11.0.
* Framework handlers supported: `files`, `csvpaths`, `errors`, `results`, `result` .
* Provides event logging, no metrics provided.
* Interoperability tested: Grafana, OpenObserve, DataDog, with other limited tests.



{% hint style="info" %}
The notes and examples for the other integrations and storage backends are in the [How-tos section](../../topics/how-tos/). And there are lots more use cases and how-tos in [the docs on https://www.flightpathdata.com](https://www.flightpathdata.com/flightpath.html).
{% endhint %}

