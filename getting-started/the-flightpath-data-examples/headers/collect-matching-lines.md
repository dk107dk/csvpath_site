# Collect matching lines

```
~
   The collect() function selects headers to collect values from when lines match.

   In this csvpath we are collecting three header values from two lines. Data from the
   matched lines is visible in the Matches tab. We'll also print to the Printouts tab
   just to make the results extra visible.

   test-data:examples/headers/projects.csv
   id: collect
~
$[*][

   #2 == "60 Kilmarnock Street"

   collect(#agency, #project_address, #period_ending)

   print_line.onmatch()
```
