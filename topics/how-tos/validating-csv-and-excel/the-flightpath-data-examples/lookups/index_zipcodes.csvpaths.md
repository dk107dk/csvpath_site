# index\_zipcodes.csvpaths

{% hint style="success" %}
Run this example using its test data from within [FlightPath Data](https://www.flightpathdata.com/).
{% endhint %}

```
~
   This csvpath creates an index of zipcodes by city from a CSV file 
   with a CITY header and a ZIPCODE header. The index will be used 
   to perform a lookup of a city's zipcode by another csvpath in a 
   different named-paths group.

   To run this example: 
     1. Load Boundaries_US_Zip_Codes.csv as a named-file called zips
     2. Load this csvpath as a named-paths group called zip_index
     3. Run zip_index against the named-file zips

   See README.md for the full example steps sequence.

   source: data.gov, catalog.data.gov/dataset/boundaries-us-zip-codes   
   test-data: lookups/Boundaries__US_Zip_Codes.csv
   name: create index
~
$[1*][
    track.zipcodes(#CITY,#ZIPCODE)
    ~ we want to index, but not to capture data, so we reject all lines ~
    no()
]
```

