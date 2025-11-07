# Duplicate lines

{% hint style="success" %}
Run this example using its test data from within [FlightPath Data](https://www.flightpathdata.com/).
{% endhint %}

```
~
   This csvpath checks for duplicate lines. If it finds any it immediately stops
   and fails the file. Note that we're doing the fail and stop at the end of the printout.
   This is just a concise way of avoiding another when/do.

   id: 4-way dup check
   test-data: examples/duplicates/Alzheimers_Disease_and_Healthy_Aging_Data_sample.csv
~
$[1*][
	@d = has_dups(#Stratification1, #Stratification2, #LocationID, #Topic)

	@d.asbool ->
print("
Duplicate found on line: $.csvpath.line_number:
Category 1: $.headers.StratificationCategory1: $.headers.Stratification1
Category 2: $.headers.StratificationCategory2: $.headers.Stratification2
Location: $.headers.4
Topic: $.headers.Topic
", fail_and_stop())

]
```
