# Sum

```
~
  sum() produces a value and also maintains a variable. You can add a name
  qualifier to enable the use of multiple sum()s or just for clarity.

  id: hello world
  test-data: examples/math/Automobiles_Annual_Imports_and_Exports_Port_Authority_of_NY.csv
~

$[1*][

  @r = random(1, 5)
  @d = divide( sum.autos_moved(#2), @r )
  @i = int( @d )
  @rr = round( @d, 2 )

  print("Line $.csvpath.line_number: divide $.variables.autos_moved by $.variables.r to get $.variables.d and cast to integer $.variables.i; alternatively rounded value $.variables.rr")
]
```
