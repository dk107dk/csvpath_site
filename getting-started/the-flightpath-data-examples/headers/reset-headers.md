# Reset headers

{% hint style="success" %}
Run this example using its test data from within [FlightPath Data](https://www.flightpathdata.com/).
{% endhint %}

```
~
   In some cases you may want to reset headers. This often happens when there are prolog lines at the 
   top of a file or if multiple datasets are joined in one file.

   When that happens you may do a reset and then need to check that the new headers are what you expect.

   This csvpath shows how to do the check on the new set of headers.

   id: reset headers
   test-data:examples/headers/projects_with_reset.csv
~
$[1*][ 

    line_number() == 18 -> reset_headers(skip())

    header_names_mismatch.u("agency|neighborhood|project|outcome")

    print(
"Line: $.csvpath.line_number:
present: $.variables.u_present
misordered: $.variables.u_misordered
unmatched: $.variables.u_unmatched
duplicated: $.variables.u_duplicated
")
```
