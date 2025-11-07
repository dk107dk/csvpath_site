---
description: CsvPath Language examples for managing CSV/Excel file headers
---

# Headers

{% hint style="warning" %}
## Try these examples yourself. They are built into FlightPath Data. You can download FlightPath Data free from [Microsoft](https://apps.microsoft.com/detail/9P9PBPKZ4JDF) or [Apple](https://apps.apple.com/us/app/flightpath-data/id6745823097) or [Github](https://github.com/dk107dk/flightpath)[Github](https://github.com/dk107dk/flightpath)
{% endhint %}

## Using headers

Headers are the names of values in a CSV or Excel file. In a delimited file, any given line may not have values for the headers. And headers can change or be found at any point in a delimited file.

CsvPath Framework has many functions to help you work with headers. Most of the functions are oriented towards creating validation rules. Some of the header functions are quite unique. For example, in CsvPath Framework, you can reset the headers to the values of the current line at any time.

These examples will help you start exploring the headers functions so you can start crafting your own rules.

<figure><img src="../../../.gitbook/assets/Screenshot 2025-08-26 at 11.58.18 AM.png" alt=""><figcaption></figcaption></figure>



```clike


---- CSVPATH ----



---- CSVPATH ----

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
