# Position check

{% hint style="success" %}
Run this example using its test data from within [FlightPath Data](https://www.flightpathdata.com/).
{% endhint %}

```
~
   Checking a header's position
   id: header name
   test-data: examples/headers/projects.csv
~
$[*][

    header_name("compliance_project_name") == 1 -> print("Position is correct!")
]
```
