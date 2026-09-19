---
description: Check your objects on the fly. No file needed.
---

# Validating JSON objects

<figure><img src="../../.gitbook/assets/Screenshot 2026-09-18 at 10.59.21 PM.png" alt="" width="375"><figcaption></figcaption></figure>

Adding data validation to your REST API or Dagster or Airflow jobs should be a snap. With CsvPath Framework, it is.&#x20;

You can treat your data objects as a:&#x20;

* JSON doc
* JSONL stream
* or a list of JSON docs&#x20;

In this page the focus is on the integration more than the contract. You have all the power of CsvPath Validation Language and JSON Schema at your disposal, but writing the perfect data contract is a different concern. Here we just want to wire up the API endpoint to its validation.&#x20;

Let's start with JSONL. And as we go, keep in mind that everything on this page works essentially the same for data frames.

### First JSONL

Here's a simple example. Say you have some animals

```json
jsonl = [
   {"a": "fish", "b": "gull", "c": "clam"},
   {"a": "ant", "b": "mouse", "c": "dog"},
   {"a": "elephant", "b": "tiger", "c": "snake"},
]
```

And you have a simple CsvPath Validation Language contract for this type of data

```javascript
~
 validation-mode: no-raise, print
~
    $dynamictest[*][
        line.animals(
            string.notnone(#a),
            string.notnone(#b),
            string(#c)
         )
         #a == "ant"
    ]
```

In this example, `dynamictest` is just a pointer, not a file path. We're going to use `dynamictest` as the name of the live data we want to work with.

We can run our validation with Python like this. Note the registration of our data under `dynamictest`, that same pointer we used in our csvpath statement.

```python
DataFileReader.register_data(path="dynamictest", data=jsonl, shape="jsonl")
#
# run the validation. we'll collect matching lines, but collecting is optional, of course.
#
path = CsvPath()
lines = path.collect(statement)
assert len(lines) == 1
#
# clear the box. in this example, not needed, but good practice.
#
DataFileReader.deregister_data("dynamictest", shape="jsonl")

```

What this code does is:

1. Register the JSON object as a JSONL- shaped data (we can treat any array of objects as JSONL)
2. Create a `CsvPath` object&#x20;
3. Collect all the lines that match our statement
4. Deregister the JSON object &#x20;

To see if our data is valid we can do:

```python
assert path.is_valid
```

To access the lines we just use the `lines` variable, a `list`:

```python
assert len(lines) == 1
```

Simple as that.

And if we want to reuse our CsvPath object without reparsing our csvpath statement, we can add this at the bottom:&#x20;

```python
path.rewind()
```

### Next JSON Documents

To validate a JSON document we need a [JSON Schema](https://json-schema.org/). Let's use this one:

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": "HabitatAnimals",
  "type": "object",
  "properties": {
    "ocean": {
      "type": "array",
      "items": {
        "type": "string"
      }
    },
    "insect": {
      "type": "array",
      "items": {
        "type": "string"
      }
    },
    "land": {
      "type": "array",
      "items": {
        "type": "string"
      }
    }
  },
  "required": [
    "ocean",
    "insect",
    "land"
  ],
  "additionalProperties": false
}
```

We'll validate this JSON object.

```
js = [
    {
        "sky": ["bluebird", "bluejay", "blue-footed boobie"],
        "insect": ["ant", "spider", "flea"],
        "land": ["elephant", "tiger", "snake"],
    },
    {
        "ocean": ["fish", "lobster", "clam"],
        "insect": ["ant", "spider", "flea"],
        "land": ["elephant", "tiger", "snake"],
    },
    {
        "below": ["mole", "badger", "worm"],
        "insect": ["ant", "spider", "flea"],
        "land": ["elephant", "tiger", "snake"],
    },
]

```

The csvpath statement changes to this one-liner:

```javascript
~ validation-mode: no-raise, print, fail ~
$dynamictest[*][
   jsonschema(SCHEMA)
]
```

Where `SCHEMA` is a fully qualified path to the JSON Schema file.&#x20;

Note the comment above the statement. It sets `validation-mode` to incude `fail`. When you add `fail` you are telling the Framework that it should mark the run as failed if there are any errors. That would be a typical approach when you're using JSON Schema. In other circumstances you might choose to not automatically mark a run failed.

The rest of the setup is largely the same:

```python
DataFileReader.register_data(path="dynamictest", data=js, shape="json")
path = CsvPath()
path.parse(stmt)
path.fast_forward()
assert path.is_valid
DataFileReader.deregister_data("dynamictest", shape="json")
```

In this case we ran the fast\_forward() method. That simply means we don't collect the matching data, which can be important for performance when you're validating large files.

### Those Are the Basics

What you've seen is a couple of ways to do what we call _ad hoc runs_. An ad hoc run is one where the only output you get is the state of your `CsvPath` object (i.e. `is_valid`, `variables`, etc.) and any data that matched your csvpath statement. Ad hoc runs are quick and easy, taking as little as one line of Python. (i.e. something like `CsvPath().fast_forward(mystatement).is_valid`)

However, the _real_ power of CsvPath Framework is its full data preboarding lifecycle. When you use all the parts together, that is when the magic happens: &#x20;

* Land files in well-organized immutable, versioned storage under cyptographic identities
* Validate and upgrade using versioned componentized data contracts
* Publish metadata to [OpenLineage](https://openlineage.io/) and [OpenTelemetry](https://opentelemetry.io/)
* Route clean and invalid data and metadata to a versioned immutable archive, and&#x20;
* Publish to downstream systems with no-code integrations

Now imagine bolting that whole **Collect-Store-Validate-Publish lifecycle** into all your APIs and streaming messaging systems. When you do that you have a consistent Edge Data Governance firewall that handles data streams as well as files, protecting all your data using precise data contracts and robust processing lifecycle.
