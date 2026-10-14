# zipcode\_lookup.csvpaths

{% hint style="success" %}
Run this example using its test data from within [FlightPath Data](https://www.flightpathdata.com/).
{% endhint %}

```
~
  This csvpath iterates a CSV or Excel file and looks up the zipcode for Boston 
  for every line.

  To run this example, first follow the steps in index_zipcodes.csvpaths to create 
  the index. Then do these steps: 
     1. Load this csvpaths file as a named-paths group call zip_lookup
     2. Run the zips named-file against zip_lookup 

   id: zip lookup
   validation-mode:raise,print
~
$[1*][ 
    @a = $bigzips.variables.zipcodes.Boston
    ~ we again want the variables but not the data, so we reject all lines ~
    no()
]
```
