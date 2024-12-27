# CsvPath Use Cases

CsvPath came out of many years of software development and DataOps experience that often involved a lot of CSV files. A couple of companies had mainframes and Access databases, yeah... that stuff. But more of them were SaaS companies creating data API products, RAG and vertical search engines, and Cloud PaaS IaC platforms. My point is, CSV is inescapable! You go where the data is.

Here are some use cases for CsvPath to get you thinking. There are many more. They have a ton of overlap, but each also has its own unique concerns. There are, of course, no cases that couldn't be handled by multiple tools. There's always more than one way to do it. CsvPath simply gives you another option—one that is purpose-built to task.

* [Ingestion](csvpath\_use\_cases.md#ingestion)
* [Inbound Batch Processing](csvpath\_use\_cases.md#batch-processing-inbound)
* [Outbound Batch Processing](csvpath\_use\_cases.md#batch-processing-outbound)
* [Monitoring](csvpath\_use\_cases.md#monitoring)
* [Sampling](csvpath\_use\_cases.md#sampling)
* [Statistical Process Control](csvpath\_use\_cases.md#statistical-process-control)
* [Data Transformation](csvpath\_use\_cases.md#data-transformation)

### Content Ingestion <a href="#ingestion" id="ingestion"></a>

Information services companies take in and generate a lot of data. As aggregators, they often ingest very large and/or wide files. And their need for conformance checking and normalization is different than that of simpler transactional flows.&#x20;

CsvPath can help in several ways:&#x20;

* Data completeness and range checking
* Cooccurance and hierarchical rules checking
* Data segmenting and routing
* Top and bottom matter handling
* Separating combined documents or distinct sections
* Rules-based and lookups-based mastering

### Batch Processing - Inbound

Inbound batch processing is the poster child for CsvPaths. Companies that regularly take in records from partners need to validate the received data as early in the intake as possible—and with maximum automation. Invoices, event records, applications, transactions, IoT, and many more types of data come in regular batches in the lowest common denominator format. Unreliable or tech-challenged business partners fall back to CSV as the most human-friendly machine-readable data format. CSV and batch processing are old friends.

* Structure correctness — header counts and names, blank lines, different length lines, etc.
* Data range — formats, lookups, ranges, ratios, etc.
* Blanks, null value corrections, field shifts
* Statistical process control _(also see below)_

### Batch Processing - Outbound

Quality control needs to happen at every stage of every pipeline. For quality control to scale it needs to be automated, not a human in the loop. Outbound batch testing gives you one last chance to verify your systems produced the output your information consumer expects. And in outbound batches, you know the whole of your data better than any one of your consumers does, so you have the ability to be more exacting. With CsvPath you can be that detail-oriented while still taking a declarative, segmented approach that helps you scale without dragging down your dev team.

### Monitoring

How often have you looked at your logging tool and found only the haystack? There must be a needle in there somewhere! Many systems can fire data at a webhook or dump to a log file. Instead of shipping raw data, in some cases you can use CsvPath to apply rules to data dumps and CSV format logs. Doing that can give more actionable information and potentially a lower cost due to sending the log system fewer bytes. A double win.

### Sampling

Sampling is core to analytics and AI. It can be hard. Not only because file sizes for data that requires sampling can be large, but also because rules and format requirements tend to turn scripts gnarly over time. Moreover, taking samples from the database may require ETL steps that are beyond the control of individual analysts or just seem like extra, unnecessary work.

* Random samples
* Rules-based sampling and repeatable samples
* Distribution checking
* Raw data set capture prior to processing
* Data munging and deidentification

### Statistical Process Control

Statistical Process Control is the use of assembly-line-like production monitoring. It uses assessment techniques that compare data to its longitudinal self and to external expectations. Lean, Six Sigma, and the [Toyota Production System](https://en.wikipedia.org/wiki/Toyota\_Production\_System) are the headline applications of SPC. Any data processing group with the ability to gather statistical indicators of their data can apply statistical methods straightforwardly. With SPC monitoring a team can methodically improve their data's conformance with expectations over time.

* Gather run and control chart inputs
* Capture and compare quintiles, standard deviation, mean, mode, etc.
* Check for correlations and co-occurrence frequencies
* Find lagging start values and unexpected clusters

### Data Transformation

CSV files and data fields often need transformation to a loadable form required by ETL or tools. In the process of transformation, the data can change in ways that are unexpected or undesired. Staging incorrectly transformed data is potentially as problematic as staging untransformed data. CsvPaths can help make transformation a declarative, simple, and self-documenting process.

* Clean fields by unwrapping, trimming, reformatting, etc.
* Normalize data
* Fill in gaps
* Find duplicates
* Separate unlike data
* Remove prolog and section artifacts
* Check for complete headers and present data fields

&#x20;

{% hint style="info" %}
These use cases and opportunity bullets were created based on CsvPath's current capabilities. You can extend CsvPath to handle more specific requirements by creating custom Python functions.&#x20;
{% endhint %}

