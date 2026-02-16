---
description: >-
  CsvPath is a Data Preboarding Framework enabling Edge Governance and Trusted
  Publishing through the Architectural Pattern called Collect, Store, Validate,
  Publish. Phew — so many buzzwords!
---

# Glossary

Buzzwords are fun. When they actually mean something they are a way to communicate important concepts in just a few words. Or they can just be buzzy. Here are some brief definitions to take the buzz out and put the meaning in.

* [Architectural Pattern](glossary.md#architectural-pattern)
* [Collect, Store, Validate, Publish](glossary.md#collect-store-validate-publish)
* [Data Preboarding](glossary.md#data-preboarding)
* [Data Upgrading](glossary.md#data-upgrading)
* [Data Validation](glossary.md#data-validation)
* [Edge Governance](glossary.md#edge-governance)
* [Trusted Publisher](glossary.md#trusted-publisher)

## Architectural Pattern

An architectural pattern is a well-definined approach to a well understood software design challenge. Architectures that are considered patterns are relatively generalized and typically pretty commonly used. The reason to use a pattern in designing software is the same as in any design-based activity, from knitting to civil engineering: higher productivity, predictability, and quality. Basically, not making it up as you go along is faster, less error-prone, and more likely to result in the thing you want. In addition, architectural patterns are useful during requirements and design discussions because they are a shorthand shared between people who know the software development domain well.&#x20;

## Collect, Store, Validate Publish

The Collect, Store, Validate, Publish pattern is a simple data preboarding pattern for ingestion external data. It manages inbound files in linear identification, validation, and upgrading steps that result in an archive of known-good, trustworthy data published to the organization's data lake and applications.

CSVP creates a Trusted Publisher intermediary that adds value to an untrustworthy external publisher. Using CSVP centralizes investment in trust-building capability. Unsurprisingly, purpose-built preboarding tools deliver better preboarding capabilities. And centralized infrastructure and operations for preboarding scales better as the number of data partners grows.

The CSVP trusted publisher becomes the data source for internal users. To do that well, CSVP:

* Collects data into an immutable store for idempotent processing
* Gives each item a durable identity
* Provides strong validation based on structure and rules
* Enables data upgrading and canonicalization
* Publishes data and metadata from a long term archive for loading into data lakes and applications

Copy-on-write semantics, simple linear processing, composable validation rules, rewind/replay capability, and lightweight distributed clients processing data under the direct control of DataOps team members are attributes that naturally fall out of the pattern, though they are not required.&#x20;

## Data Preboarding

Data preboarding is a term for any approach to bringing external datasets into the organization in a controlled way that protects the company's data environment by catching problems at the parameter. In concept external publishers are both untrustworthy and not responsible for starting the chain of custody and data identification that makes data coherent before it goes into the data lake. Data coming into the enterprise will always be identified, validated, upgraded, and staged in some way. The question is how well is that done? Too often it is not done well across the board. A solid data preboarding process boosts quality and productivity, and protects the company's reputation; whereas, an ad hoc, effort-minimizing, or unacknowledged data preboarding process raises costs and is corrosive to the company's reputation over time.&#x20;

## Data Upgrading

Data upgrading is similar, but not identical, to canonicalization. It is the process of smoothing the rough edges in order to make data comparable and accessible.&#x20;

Upgrading includes modest changes like:&#x20;

* Conforming capitalization
* Using a single type of quotation marks and delimiters
* Removing excess space
* Synchronizing date formats
* Etc, etc.

This is not big transformation stuff. And it is not data mastering. Rather it targets basic error prevention and productivity.

## Data Validation

Validation is the act of making certain that an item of data meets expectations. That much is clear. But there are four important concepts that come under the heading of validation. [We talked about them here](/broken/pages/WyOBYI18DAvLZ2m78nsJ). In super brief terms:&#x20;

* Well-formedness — is the data machine-recognizable as what human judgement says it must be?
* Valid — does the data follow expected rules for data of the purpose the data is intended fulfill?
* Canonical — does each element of data match expectations for form and semantics?
* Correct — does the data accurately reflect the operating business?

## Edge Governance

Edge governance is the set of data governance processes that control data at the parameter of the organization. This set of processes is time and scope limited. Edge governance has the focus the moment data is presented to the organization and completes the moment the internally published data moves to the operational system of record — typically a data lake or data warehouse. At that point, for a given item of data, data governance shifts to other tools and processes; while the edge governance process continues with new data and maintains the archival history and immutable forms of transited data.&#x20;

While we most often focus on inbound data flows, edge governance is also applicable to the data outflow from the moment operational systems make data available for distribution to the moment externally published data is presented to the data partner. Typically outflow publishing is seen as less risky and higher trust by the publishing organization; however, outbound edge governance can reduce errors and consolidate processes, as well as potentially bolstering compliance and security.

## Trusted Publisher

In DataOps, the question of who to trust and how much is fraught. There are few natural controls on external publishers and transparency is typically poor. Not trusting data partners completely, while pragmatic, can be costly. One of the best ways to deal with the data-not-under-your-control problem is to put a trusted publisher between the external partner and the operational data stores and applications.&#x20;

This internal publisher has the responsibility for regulating the flow of data and assuring it meets a standard of quality and traceability that allows the operational systems to operate with high-trust. The high-trust data environment allows the applications and analytics to focus more effort on the business the data supports and less on being data-defensive. In custom applications and analytics in particular, this separation of focus — preboarding as the trust-building publisher, applications being fully business focused — leads to higher productivity for all.
