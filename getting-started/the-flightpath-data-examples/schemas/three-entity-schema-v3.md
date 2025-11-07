# Three entity schema v3

```
---- CSVPATH ----
~
   id: example three
   description: Extra wildcard at end of contact
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
		wildcard(3)
	)
	line.contact(
		wildcard(6),
		email(#email),
		url(#linkedin),
		string.cell(#phone),
		wildcard()
	)

    last.nocontrib() -> print("See the Matches tab for valid lines")
 ]
```
