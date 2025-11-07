# Min and max

```
~
  This csvpath shows the min() and max() functions' potential to mirror the
  increase and decrease qualfiers. Look in the Variables tab to see the results.

  Notice that increase and decrease will do a lexical comparison if you don't
  pass them numbers. min() and max() convert to numbers, but plain headers
  are always strings until you do something with them.

  id: min-max
  test-data: examples/math/Automobiles_Annual_Imports_and_Exports_Port_Authority_of_NY.csv
~
$[1*][
	@m1 = max(#"Automobile Volume")

	@m2.increase = int(#"Automobile Volume")

	@m3 = min(#"Automobile Volume")

	@m4.decrease = int(#"Automobile Volume")

  last() ->
    print("
    m1: $.variables.m1
    m2: $.variables.m2
    m3: $.variables.m3
    m4: $.variables.m4
   ")
]
```
