# Percents

```
~
   This csvpath checks if the % unique values is below 90% after at least 20% of years
   have been checked.

   id: percent unique
   validation-mode: raise, print, stop
   test-data: examples/math/Automobiles_Annual_Imports_and_Exports_Port_Authority_of_NY.csv
~
$[1*][
   @reviewed = percent("scan")
   @uniques = percent_unique.units(#"Automobile Volume")

   below( @reviewed, .20 ) -> skip()
   below( @uniques, 90 ) -> print("Line $.csvpath.line_number looks wrong: $.variables.uniques")
]
```
