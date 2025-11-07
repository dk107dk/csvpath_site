# Running median and average

{% hint style="success" %}
Run this example using its test data from within [FlightPath Data](https://www.flightpathdata.com/).
{% endhint %}

```
~
  Here we have the running median and the running average. The end result in variables @a and
  @m are for the full list of numbers. However, @a and @m are available at each line as the
  average and median of the lines scanned to that point.

  id: ave and median
  validation-mode: print, stop
  test-data: examples/math/Automobiles_Annual_Imports_and_Exports_Port_Authority_of_NY.csv
~
$[1*][
     @a = average(#"Automobile Volume")
     @m = median(#"Automobile Volume")

     last() ->
     print("Final average: $.variables.a
Final median: $.variables.m
See variables for running values.
")
]
```
