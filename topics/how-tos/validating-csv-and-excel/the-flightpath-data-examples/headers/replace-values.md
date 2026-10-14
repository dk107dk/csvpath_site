# Replace values

{% hint style="success" %}
Run this example using its test data from within [FlightPath Data](https://www.flightpathdata.com/).
{% endhint %}

```
~
   This csvpath updates the "compliance_project_name" header when it sees a certain value.
   Because we used the nocontrib qualifier the csvpath still returns all lines even though
   we are selecting a subset.

   id: replacing

   test-data:examples/headers/projects.csv
~

$[*][
	#compliance_project_name.nocontrib == "350 Boylston Street" ->
	replace(#compliance_project_name, "New Co. Build")

      last() -> print("See Matches tab for replacements")
]
```
