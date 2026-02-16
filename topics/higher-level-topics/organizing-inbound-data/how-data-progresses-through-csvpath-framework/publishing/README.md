# Publishing

### CsvPath Framework is the Trusted Publisher

CsvPath Framework is the internal trusted publisher for your data lake, streaming infrastructure, data warehouse, applications, and/or other analytical processing.&#x20;

<figure><img src="../../../../../.gitbook/assets/Screenshot 2025-03-30 at 11.59.50 AM.png" alt=""><figcaption></figcaption></figure>

### What does that mean?&#x20;

It means that data published by CsvPath is either known-good or known-bad to a certain organizationally-defined standard. The data lake receives data at a certain minimal level of trustworthiness. The applications receive data that has passed quality, business, and governance checks so the application doesn't have to enforce those itself. The analytics team can go back to an immutable source with clear, detailed provenance any time their results come into question. **Data trust is efficient and transitive**. If the data lake can trust its data source, the downstream data consumers can trust the data lake.&#x20;

### What does publishing mean?

The Trusted Publisher can provide data in a push or a pull mode. CsvPath Framework can push data to the data lake or other data consumers by SFTP transfer, filesystem transfer, or pointing the Archive backend to a bucket or other location. Alternatively, the downstream consumer(s) can reach into the Archive, wherever you configure it to be, to access the data they need. Both work.

From a data operations perspective, the Trusted Publisher can sit on the same infrastructure as the data lake — essentially the CsvPath Framework backend is in the data lake — or it can stand separately as an upstream data source. Since we would expect CsvPath Framework to run in an automated, highly controlled way, either approach works fine. It just depends on how your team and its governance activities are organized.

