# Intersection

{% hint style="success" %}
Run this example using its test data from within [FlightPath Data](https://www.flightpathdata.com/).
{% endhint %}

```
~
   This csvpath is roughly equal to this SQL:
	SELECT 
	  street, 
	  city 
	FROM shipping_address
	INTERSECT
	SELECT 
	  street, 
	  city 
	FROM billing_address

   We set up the schemas for the shipping address and billing address, just 
   for clarity; whereas, the SQL query only tests for street and city being  
   equal. 

   To be more equivalent, the csvpath would just be: 
	#3 == #9
	#4 == #10
	collect(#street, #city)

   This is not a very realistic case, but it is interesting for the 
   comparison to SQL. CSV and SQL schemas have many commonalities.

   In the second line() definition we use the header indexes rather than the 
   names. That is because we have conflicting header names. Header names are 
   found by searching left to right, so we're fine with the first line() 
   definition. But the second line()'s headers would not be found if we used
   the header names. This is exactly the kind of thing index references are
   for. Because we can do this, our csvpath finds a number of schema violations
   for the second line().

   Notice that we are naming the schema fields, rather than just leaving them
   to be understood from the header names. This is partly because of the index
   header references. But it is more valuable because we will have errors on
   the second line() in line 4 because of the not-nones. The error messages 
   will be easier to understand if we add the names to the string()s. It is 
   optional, but definitely helps in some cases, like this one.
 
   Note that for this to be a useful example we need validation-mode to be set
   to no-raise, so the full run happens despite errors. And we gain easier
   debugging errors messages and make the schemas self documenting by adding
   the names shipping and billing to the line() functions.

   id: addresses
   test-data: examples/schemas/shipping.csv
   validation-mode:print, no-raise
~
$[1*][
  ~ we don't really need the two line() schemas, but for comparison 
    to SQL we'll go ahead and create them ~
    
	line.shipping(
	   blank(#0), ~ this blank() is a placeholder for the ID header ~
	   string.notnone.addressee(#1),
	   string.unit(#unit),
     string.notnone.street(#street),
     string.notnone.city(#city),
     string.notnone.state(#state, 2, 2),
     integer.notnone.postcode(#zip),
	   wildcard()
	)
	line.billing(
	   wildcard(7),
	   string.notnone.payee(#payee),
	   string.unit(#unit),
     string.notnone.street(#9),
     string.notnone.city(#10),
     string.notnone.state(#11, 2, 2),
     integer.notnone.postcode(#12, 99999, 0)
	)
	#3 == #9
	#4 == #10
	collect(#street, #city)
]

```
