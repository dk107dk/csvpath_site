# Name check

{% hint style="success" %}
Run this example using its test data from within [FlightPath Data](https://www.flightpathdata.com/).
{% endhint %}

```
~
   One way to check a header's name
   id: header name
   test-data: examples/headers/projects.csv
~
$[1*][

    @name = header_name(1)
	@name == "compliance_project_name" -> print("Name is correct!")

]
```
