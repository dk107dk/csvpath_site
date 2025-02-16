---
description: >-
  CsvPath is a Data Preboarding Framework enabling Edge Governance and Trusted
  Publishing through the Architectural Pattern called Collect, Store, Validate,
  Publish. Phew — so many buzzwords!
---

# Glossary

Buzzwords are fun. When they actually mean something they are a way to communicate important concepts in just a few words. Or they can just be buzzy. Here are some brief definitions to take the buzz out and put the meaning in.

## Architectural Pattern

An architectural pattern is a well-definined approach to a well understood software design challenge. Architectures that are considered patterns are relatively generalized and typically pretty commonly used. The reason to use a pattern in designing software is the same as in any design-based activity, from knitting to civil engineering: higher productivity, predictability, and quality. Basically, not making it up as you go along is faster, less error-prone, and more likely to result in the thing you want. In addition, architectural patterns are useful during requirements and design discussions because they are a shorthand shared between people who know the software development domain well.&#x20;

## Collect, Store, Validate Publish

The Collect, Store, Validate, Publish pattern is a simple preboarding data ingestion pattern. It manages inbound files in linear identification, validation, and upgrading steps that result in an archive of known-good, trustworthy data published to the organization's data lake and applications.

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

Validation is the act of making certain that an item of data meets expectations. That much is clear. But there are four important concepts that come under the heading of validation. [We talked about them here](validation/well-formed-valid-canonical-and-correct.md). In super brief terms:&#x20;

* Well-formedness
* Valid
* Canonical
* Correct

## Edge Governance



## Trusted Publisher

