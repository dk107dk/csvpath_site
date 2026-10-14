# Validating XML Using XSD

XML Schema Definition Language — or XSD — is a powerful tool for declaring a data model and asserting a dataset conforms to it.  While it is complex and carries XML's verbosity tax, XSD has few equally comprehensive and flexible peers in modeling data.

CsvPath Framework offers the usual two approaches to validating data using XSDs:

* Standalone validation resulting in a live metadata
* Embedded in the Framework's comprehensive data preboarding workflow

The former is great for pipelines, API backends, scripts. The latter is the option to choose if you have strict governance requirements and need an immutable archive and source of truth at the ingress point.



Validating XML is very similar to validating using any of CsvPath Framework's validation languages. XSD always needs a runner wherever you use it. A trivial csvpath statement is all that's needed in CsvPath Framework.&#x20;

This is probably the simplest possible example:

```python
    def validate_model_year(self):
        path = CsvPath()
        path.parse(f"""
                $imports/2026.xml[0][ xsd("xsds/automobiles.xsd") ] 
        """).fast_forward()
        assert path.is_valid is True
```

Happily it is also not far from being the most complex standalone XSD validation example. And as usual, you can get the errors, printouts, metadata, and variables from the `CsvPath` instance. If you run the `collect` method, instead of `fast_forward`, you get the matching lines as well.

### A data preboarding XSD example

The full data preboarding workflow adds immutability, telemetry, no-code integrations, and historic data and metadata. To get all that, alll we need to do is register our data and load the csvpath statement driver as a named-paths group.

Here's the driver csvpath:&#x20;

```json
$[0][ xsd("automobiles.xsd") ]
```

We're going to add this XSD to the named-paths group. That allows us to refer to it by name, not by path.&#x20;

Note that we're setting a scan instruction of `[0]`, meaning scan just the first line. When you use the xsd() function in your csvpath, the CsvPaths instances stops your path seeing any further lines, so that `[0]` could be `[5]` or `[*]` and the effect would be the same. The reason for this is that you are looking at the XML document as a whole. Read line by line through the file would be problematic and wasteful. If you wanted to apply XPath rules outside the XSD to the same file, you would simply create another driver csvpath using the `xpath()` function and add it to the same named-paths group.

The XSD could be:&#x20;

```xml
<?xml version="1.0" encoding="UTF-8"?>
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xs:element name="goods">
    <xs:complexType>
      <xs:sequence>
        <xs:element name="automobile">
          <xs:complexType>
            <xs:sequence>
              <xs:element name="annual" maxOccurs="unbounded">
                <xs:complexType>
                  <xs:sequence>
                    <xs:element name="imports" type="xs:nonNegativeInteger"/>
                    <xs:element name="exports" type="xs:nonNegativeInteger"/>
                  </xs:sequence>
                  <xs:attribute name="year" type="xs:gYear" use="required"/>
                </xs:complexType>
              </xs:element>
            </xs:sequence>
          </xs:complexType>
        </xs:element>
      </xs:sequence>
    </xs:complexType>
  </xs:element>
</xs:schema>
```

The XML might be like:&#x20;

```xml
<goods>
    <automobile>
        <annual year="2012">
            <imports>404975</imports>
            <exports>302441</exports>
        </annual>
        <annual year="2011">
            <imports>366768</imports>
            <exports>283901</exports>
        </annual>
        <annual year="2010">
            <imports>469315</imports>
            <exports>225964</exports>
        </annual>
        <annual year="2009">
            <imports>423425</imports>
            <exports>194406</exports>
        </annual>
    </automobile>
</goods>
```

With those inputs, the Python required looks like this: &#x20;

```python

    def valdiate(self) -> None:
        paths = CsvPaths()
        name = "autos"
        
        ~ load the named-entities ~
        paths.paths_manager.add_named_paths(name=name, from_file="autos.csvpaths")
        paths.file_manager.add_named_file(name=name, path="autos.xml")

        ~ add the XSD to the named-paths group. 
          DataFileReader can read from any Framework backend. ~
        with DataFileReader(XSD) as reader:
            text = reader.source.read()
            paths.paths_manager.asset_manager.store_asset_file(
                name=name, filename="automobiles.xsd", contents=text
            )

        ~ do the run and check the results using the run reference ~        
        ref = paths.collect_paths(pathsname=name, filename=name)
        results = paths.results_manager.get_named_results(ref)        
        assert results[0].csvpath.is_valid

```

You can use `DataFileReader` or simply use the basic Python `open()`, whichever works best for your use case. And, although we used the name `"autos"` in several places you can use whatever names you like, they don't have to all be the same.

That's all there is to it. When you run this example you'll see another run in the archive under `"autos"` with all your data and metadata.&#x20;
