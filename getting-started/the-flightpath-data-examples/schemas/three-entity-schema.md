# Three entity schema

```
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
```
