# Last duplicate seen

{% hint style="success" %}
Run this example using its test data from within [FlightPath Data](https://www.flightpathdata.com/).
{% endhint %}

<pre><code><strong>~
</strong>   This example uses some very artifical SAP CSV data to show a duplicate check
   on the transaction ID header. If a duplicate is found we print the error  
   with the most recent time the ID was seen.

   id: sales
   test-data: duplicates/sales.csv
   validation-mode:raise, print
~
$[*][ 
	@d = has_dups(#transactionId) 	

	~ if we have a duplicate, find the last time we saw it ~
	@d.asbool -> @last = get(@track, #transactionId)

	~ again, if we have a duplicate, this time print the error ~
	@d.asbool -> print("On line $.csvpath.line_number ID '$.headers.transactionId' is a duplicate ID last seen at $.variables.last")

	~ update our map of ID->time pairs so we can look back, if neeeded ~	
	track(#transactionId, #transactionCreatedDateTime)	
]


</code></pre>
