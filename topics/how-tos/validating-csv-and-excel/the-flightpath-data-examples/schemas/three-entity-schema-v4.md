# Three entity schema v4

{% hint style="success" %}
Run this example using its test data from within [FlightPath Data](https://www.flightpathdata.com/).
{% endhint %}

```
~
   id: example four
   description: Unnecessary wildcard at end of contact and a distinct.
   test-data: examples/schemas/people.csv
~
$[1*][
    line.person(
		integer.id.notnone(#0),
		string.notnone(#given_name),
		string.notnone(#family_name),
		wildcard()
	)
	line.address(
		wildcard(3),
		string(#city),
		string(#state, 2),
		string(#zipcode),
		wildcard()
	)
	~
	  because each entity ends with a wildcard() with no specified length this
 	  line can continue as far to the right as needed ~
	line.distinct.contact(
		wildcard(6),
		email(#email),
		url(#linkedin),
		string.cell(#phone),
		wildcard()
	)

    last.nocontrib() -> print("See the Matches tab for valid lines")
 ]
```
