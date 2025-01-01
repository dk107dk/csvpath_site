# Well-formed, Valid, Canonical, and Correct

The world of data is messy. It's full of terms-of-art with squishy definitions. And people who use terms in ways their perspective or product, but may not be commonly accepted. This page tackles the definitions of a few data management terms that are often used loosely. I'll say up front two things: 1) this page is a stub to be filled in over time, and 2) you may not agree with my definitions.&#x20;

## **Well-formed**

Data that is well-formed first and foremost matches a physical specification, and, secondly, has the correct "outline" to be an item of data of the form expected.&#x20;

## **Valid**

Files that are valid have data that is compared against a definition of what good data looks like. Data can be validated using rules or models. An `XSD` is primarily a model. A `Schematron` file is principly rules. In fact, a model is a short-hand way of writing rules. And, in this context, a set of rules is just a classification. But in practice it's simple: an item of data that doesn't match its schema is considered invalid.

## Canonical

A canonical form is the form that is preferred over other possible forms of the same data. A simple example is the term `IBM`. Its canonical form may be `IBM`. It may also be seen as `I.B.M.` or `International Business Machines`. If we are canonicalizing data using this mapping to `IBM` and we see `I.B.M.` we substitute the canonical form. Note that if there are multiple accepted forms the canonical form is any of them.&#x20;

## Correct

Correct data is more than well-formed + valid + canonicalized. Correct means that the semantic and business rule content of the data meets expectations. For example, imagine a `CSV` file that includes a list of companies. Each company has an area of commercial activity. We see that:&#x20;

* The file is readable as a `CSV` file, so it is well-formed
* The file has values under all headers in all rows, so for our purposes we'll call it valid
* The company name `I.B.M` has been canonicalized to `IBM` so we'll say that the data is in a canonical form
* And the company listed as `IBM` is described as being in the business of `Sunflower Farming`

Due to the last bullet having sketchy intelligence — we don't think `IBM` grows sunflowers — we'll say that this data is incorrect.
