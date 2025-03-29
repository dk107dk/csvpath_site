---
description: Why we all need to care about data preboarding and the trusted publisher model
---

# DATA PREBOARDING

CsvPath is the leading tool for automated data preboarding. It is a purpose-built open source Python framework integrated with a wide variety of popular DataOps tools that acts as a trusted publisher between MFT and the data lake and applications.&#x20;

## What is Data Preboarding?

Data preboarding is the receiving process for external batch data. It is the first part of a robust data onboarding process. Preboarding assigns a durable identity, validates that the data meets expectations, upgrades it for productivity, and stages it in an immuable known-good archive for downstream consumers. **Your data lake deserves a data publisher it can trust!** Once data is preboarded it is no longer considered external.

<figure><img src=".gitbook/assets/Screenshot 2025-02-10 at 11.10.16 AM.png" alt="A checklist of the capabilities of a preboarding architecture like CsvPath Framework: durable identification, validation, data upgrading, canonicalization, consistent immutable staging as a trusted publisher to downstream data users." width="375"><figcaption></figcaption></figure>

Data preboarding may be a new term to you, or not; either way it is not a new concept. All data is preboarded on its way into the organization. The question is, how well does your onboarding process work? The experience of most companies is that the process is less reliable, holds more risk, and is much more expensive than is comfortable. **Manual and error prone preboarding commonly diverts more than 2% of revenues to overhead**. That's north of $20,000 per million or more than $20 million per billion in revenue. That adds up! &#x20;



<figure><img src=".gitbook/assets/csvpath-word-only-blue-sm.png" alt="The CsvPath Framework logo" width="255"><figcaption></figcaption></figure>

## How does the CsvPath Framework help? &#x20;

CsvPath is a drop-in replacement for rickety data landing zones. It is  laser-focused on automated data preboarding. The Framework focuses on making the overall onboarding process efficient, fast, and safe by generating trustworthy data — and doing it in a way that scales operationally to any number of data partners. A company with one data partner needs effective preboarding. A company with a thousand data partners needs efficient preboarding that never fails. CsvPath Framework can help!

CsvPath brings many capabilities to the table:&#x20;

* An opinionated framework for collecting, identifying, validating and publishing data that enables you to spin up a new data partner project literally in seconds
* Powerful schema and rules-based validation that has never before been available for delimited data
* Explainability-focused metadata production that gives you the power to know exactly what happened as your data evolved
* Out-of-the-box integrations for lineage tracking, observability, MFT (managed file transfer), and more

With CsvPath Framework you are signing up for a well-known pattern that settles the architecture and design questions up-front, leaving your team focused on data quality and accountability. And with CsvPath's the automation-forward approach, you can scale-down manual data quality efforts and scale up data throughput.

<figure><img src=".gitbook/assets/Screenshot 2025-02-09 at 8.32.52 PM.png" alt="A super high-level data flow diagram showing how data files and validation/upgrading files are combined to create known-good data for downstream data consumers." width="563"><figcaption><p>CsvPath is a pre-packaged automation-focused preboarding process.</p></figcaption></figure>

## How to get started

If you are a developer, take a look at the [Quickstart ](getting-started/quickstart.md)and the [Your First Validation](getting-started/csv-and-excel-validation/your-first-validation-the-lazy-way.md) exercises. They will get you up and running and introduce the CLI, the fastest way to get started. Reading about [schemas vs. rules-based validation](topics/validation/schemas-or-rules.md) would be useful. Take a look the [How-tos](getting-started/how-tos/) and [DataOps integrations](getting-started/integrations/) sections. There is a [cheatsheet](topics/a-csvpath-cheatsheet.md) and [validation language basics](topics/language.md). And there is more information on the[ GitHub site](https://github.com/csvpath/csvpath).

For a higher-level view on the topics of edge governance and data preboarding, try the [atesta analytics  whitepapers](https://www.atestaanalytics.com/downloads). They are CsvPath focused, but speak to the overarching operational and organizational needs.

Data pre-boarding is everywhere. And yet it is dramatically undertooled. We're on a mission to upgrade preboarding and make CsvPath Framework the world's trusted publisher. Welcome aboard!
