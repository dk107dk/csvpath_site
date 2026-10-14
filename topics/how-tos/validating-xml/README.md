---
description: The Framework includes two ways to validate both of two forms of XML
---

# Validating XML

CsvPath Framework supports XML as:

* Single XML document per file
* Inline XML embedded within a CSV or JSONL file (flattened into a string within a header)

When you validate XML you have three choices:

* You can use XSD ([XML Schema Definition language](https://www.w3.org/TR/xmlschema11-1/))
* Alternatively you can use XPath rules, or
* You can use both XSD and XPath&#x20;

(The latter meaning within the Framework as separate complementary approaches. You can also apply certain XPath statements within an XSD, if you prefer that style).

XSDs are relatively complex, but well known and with good tools. (Shoutout to XMLSpy for great XSD visualization).&#x20;

Using XPath to validate XML is probably a bit less common. The standard for XPath validation is [Schematron](https://www.schematron.com/). CsvPath Framework doesn't support Schematron. However, CsvPath Validation Language was actually inspired, in part, by Schematron, and can do essentially the same thing, but with cleaner, simpler syntax. We love using XPath to validate XML and we think, naturally, that CsvPath Validation Language is a more delightful way to do it. We may be biased.&#x20;

