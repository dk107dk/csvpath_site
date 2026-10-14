# Above average

{% hint style="success" %}
Run this example using its test data from within [FlightPath Data](https://www.flightpathdata.com/).
{% endhint %}

```
~
  These two csvpaths, when loaded into one named-paths group called 
  "above-ave", are roughly equal to this SQL:

   SELECT 
     year, 
     type, 
     volume
   FROM autos  
   WHERE volume > ( SELECT AVG(volume) FROM autos )

   id: find average
   test-data: examples/math/Automobiles_Annual_Imports_and_Exports_Port_Authority_of_NY.csv
~
$[1*][ @ave = average(#2) ]

---- CSVPATH ----

~
   id: use average
~
$[1*][
	below.nocontrib(#2, $above-ave.variables.ave) -> skip() 
	print("$.headers.2 is above $above-ave.variables.ave")
]
```
