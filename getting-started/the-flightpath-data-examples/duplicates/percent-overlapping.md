# Percent overlapping

```
~
   Find the % of overlapping records for three headers.
   name:
   test-data: examples/duplicates/Alzheimers_Disease_and_Healthy_Aging_Data_sample.csv
~

$[1*][
   dup_lines(#Stratification1, #Stratification2, #LocationID)
   @p = percent("match")
   @p = multiply(@p, 100)
   @p = int(@p)
   last.nocontrib() -> print("Out of $.csvpath.line_number lines with $.csvpath.count_matches matches, $.variables.p% overlap on age, race, and location")
]
```
