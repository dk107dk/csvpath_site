---
description: Examples of using CsvPath Language schemas to validate CSV/Excel data
---

# Schemas

## Making schemas for CSV and Excel

CsvPath Framework supports data validation using schemas and rules. Both approaches have their own strengths.

This example shows how to create a simple schema that functions much like a SQL DDL schema.

The DDL example is in the file person.sql.txt. It has a simplistic 3-table model of a person with address and contact information.

The examples in the file schemas.csvpath show four variations on an analogous CsvPath schema that can be used with a CSV or Excel file.

Run any of the csvpaths by putting your cursor in the csvpath you want to run and typing **control-r** or right-clicking and selecting **Run**.

<figure><img src="../../../.gitbook/assets/Screenshot 2025-08-26 at 12.07.01 PM.png" alt=""><figcaption></figcaption></figure>

```clike
~
   This schema shows a three-entity line structured as a person, their
   address, and their contact info, all side-by-side. The first entity, the person,
   starts at the left-most header. The other two entities start at well defined
   locations in the line.

   line() functions can overlap. For example, you could define a person to have an
   age, height, and weight, while also defining a second line() entity with health
   demographics including those same headers.

   line()s can be distinct. Adding a distinct qualifier requires all the header
   values combined from one line to be unique within the data file. You may use
   multiple line() functions to create the set of distinct constraints you need.
   For example, a line.person.distinct() might contain the first, middle, and
   last name plus the last 4 of a person's social security number. Another
   line.drivers_id() within the same CsvPath schema might require the last name
   and drivers license number pair to also be unique.

   id: example one
   description: Exactly the right headers and wildcards
   test-data: examples/schemas/people.csv
~
$[1*][
	~ this is the first entity in a line ~
         line.person(
		integer.id.notnone(#0),
		string.notnone(#given_name),
		string.notnone(#family_name),
		wildcard()
	)
	~ this is a second entity ~
	line.address(
		wildcard(3),
		string(#city),
		string(#state, 2),
		string(#zipcode),
		wildcard(3)
	)
	~ and this is the last ~
	line.contact(
		wildcard(6),
		email(#email),
		url(#linkedin),
		string.cell(#phone)
	)
	~  Just to see something in the printouts let's say hello. ~
	@name = concat(caps(#1), " ", caps(#2))
	print("Hello $.variables.name")
]

---- CSVPATH ----
~
   id: example two
   description: 2 wildcards in address
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
	line.contact(
		wildcard(6),
		email(#email),
		url(#linkedin),
		string.cell(#phone)
	)

    last.nocontrib() -> print("See the Matches tab for valid lines")
 ]

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

---- CSVPATH ----
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



