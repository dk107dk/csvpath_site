# End

{% hint style="success" %}
Run this example using its test data from within [FlightPath Data](https://www.flightpathdata.com/).
{% endhint %}

```
~
  The end() function returns the value of the last header. If you pass it an int N it will
  return the value of the header at the index: count_headers_in_line() - 1 - N. (The minus 1
  is because a count of the headers is 1-based; whereas, the index of a header is 0-based).

  To make the example a bit more interesting, we add the onchange qualifier to the variable
  assignment. That makes this variable assignment contribute a vote to matching lines. The
  onchange qualifier's main function is to limit an action to when it sees new information.

  Because we put onchange on the variable the Matches tab shows 9 lines. We could alternatively
  have put onchange on the print() function so we print only when the data changes, but still
  match every line.

  id: last column
  test-data: examples/headers/projects.csv
~

$[1*][
    @last_header_value.onchange = end(6)

    print.onmatch("$.variables.last_header_value")
]
```
