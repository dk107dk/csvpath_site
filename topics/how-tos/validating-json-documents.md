---
description: Using JSON Schema in CsvPath Framework
---

# Validating JSON Documents

<figure><img src="../../.gitbook/assets/json.png" alt="" width="188"><figcaption></figcaption></figure>

JSON documents are everywhere, from FHIR to GeoJSON to Sellers.json. When you need to validate JSON documents you need JSON Schema.&#x20;

{% hint style="info" %}
_On the other hand, if you have relatively flat JSONL you may want to stick with CsvPath Validation Language — now you have options!_
{% endhint %}

Using JSON Schema in CsvPath Framework is easy. The steps are:

* Create a JSON Schema
* Create a 1-line CsvPath statement to run it
* Load your CsvPath statement and JSON Schema into a validation group
* Register your file&#x20;
* Do your run

Voila, you get the same validation outputs as you would from any CsvPath Framework validation:

* data.json&#x20;
* errors.json
* vars.json
* meta.json
* manifest.json
* printouts.txt (or any individual reports you create)

### A Simple Example

First, the CsvPath Language driver. Only lines 4-6 are actually required.&#x20;

Lines 1-3 configure a specific set of actions (or non-actions) to take when errors are found in the data. Here we're going to fail the run on error, print the error message, and suppress exceptions so the run completes without interruption, even if there is an error.

<div data-with-frame="true"><figure><img src="../../.gitbook/assets/1 (2).png" alt=""><figcaption></figcaption></figure></div>

Next the Python that makes the magic happen.&#x20;

You can do this in [FlightPath Data](https://www.flightpathdata.com/) without any code. Before you try that, check that your version supports JSON Schema validation.

<div data-with-frame="true"><figure><img src="../../.gitbook/assets/2 (2).png" alt=""><figcaption></figcaption></figure></div>

Add a simple JSON Schema to verify our file of import/export automobile data meets expectations.

<div data-with-frame="true"><figure><img src="../../.gitbook/assets/Screenshot 2026-09-15 at 6.18.11 PM.png" alt=""><figcaption></figcaption></figure></div>

And here is the result of the run.&#x20;

<div data-with-frame="true"><figure><img src="../../.gitbook/assets/Screenshot 2026-09-15 at 6.13.01 PM.png" alt=""><figcaption></figcaption></figure></div>

This view is the key point: all your validation assets from JSON Schema are exactly the same. You get the same rich metadata, the same OpenLineage and OpenTelemetry events, and the same reporting capabilities for JSON Schema as you do for CsvPath Validation Language.&#x20;

Your edge data governance of Excel and JSON and JSONL/NDJSON and CSV and XML all happen in exactly the same way. That's control you can use.

