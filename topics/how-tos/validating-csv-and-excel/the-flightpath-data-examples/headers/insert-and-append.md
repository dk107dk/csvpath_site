# Insert and append

{% hint style="success" %}
Run this example using its test data from within [FlightPath Data](https://www.flightpathdata.com/).
{% endhint %}

```
~
   This csvpath updates the test file data to have a processing date at the 0th header
   and a "modified by" header at the end of the line.

   id: insert and append

   test-data:examples/headers/projects.csv
~
$[*][

	insert( 0, "processing date", now() )
         append( "modified by", "CsvPath", yes() )

	last.nocontrib() -> print("See the Matches tab for the new column at the end of every line")
]
```
