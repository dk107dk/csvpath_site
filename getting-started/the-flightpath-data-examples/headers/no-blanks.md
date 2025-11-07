# No blanks

```
~
   When used without arguments, all() returns True (it matches) when all headers 
   have values. 

   all()'s opposite is the missing() function. In this example we are looking for 
   any lines where a header has no value. We could use missing(), but to make 
   a more interesting example, we are using return-mode to return only lines that
   do not match.
   
   On the last line we print a tally of lines and matches. Notice that we add a 
   nocontrib qualifier to last(). nocontrib means that the match component with 
   that qualifier does not contribute to matching. If we didn't add nocontrib the
   last() would only match with the last line. Since we are interested in all(), 
   not last(), we use nocontrib to neutralize last().

   return-mode:no-matches
   id: missing example
   test-data:examples/headers/projects.csv
~

$[*][ 

	all()

	last.nocontrib() -> 
               print("Lines: $.csvpath.line_number, Matches: $.csvpath.count_matches")
]
```
