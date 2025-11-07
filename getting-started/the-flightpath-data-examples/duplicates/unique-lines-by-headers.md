# Unique lines by headers

{% hint style="success" %}
Run this example using its test data from within [FlightPath Data](https://www.flightpathdata.com/).
{% endhint %}

```
~
   Find all the lines that don't have at least one other
   year/location match out of a 5000 line sample.

   FlightPath will ask if you want to create a smaller sample file. This
   example runs quickly as-is, but in general smaller samples are better
   during iterative development. In particular, doing many printouts can
   slow runs down.

   To create a sample first click on the data file in the left-hand tree,
   Alzheimers_Disease_and_Healthy_Aging_Data_sample.csv. Then look at the
   top of FlightPath for the data toolbar and click the "Save sample as"
   button. After creating the sample you need to change the "test-data"
   path, below, so it points to your new sample file. Or, if you remove
   "test-data", you will be prompted to pick a file each time you run this
   csvpath.

   id: dup lines
   test-data: examples/duplicates/Alzheimers_Disease_and_Healthy_Aging_Data_sample.csv
~

$[*][

   not( dup_lines( #YearStart, #LocationAbbr ) )

   last.nocontrib() -> print("See the matches tab for the unique lines")
```
