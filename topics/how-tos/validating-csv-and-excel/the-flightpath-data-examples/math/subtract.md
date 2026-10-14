# Subtract

{% hint style="success" %}
Run this example using its test data from within [FlightPath Data](https://www.flightpathdata.com/).
{% endhint %}

```
~
  Subtract is similar to add, multiply, and divide, but it has the additional
  ability to negate a value. (This example uses the alias minus())

  id: minus and subtract
  validation-mode: raise, print, stop
  test-data: examples/math/Automobiles_Annual_Imports_and_Exports_Port_Authority_of_NY.csv
~
$[1-2][
	@i = random(1,3)
         @minus_i = minus(@i)
	@r = subtract(@i, @minus_i)
	print("$.variables.i subtract $.variables.minus_i = $.variables.r")
]
```
