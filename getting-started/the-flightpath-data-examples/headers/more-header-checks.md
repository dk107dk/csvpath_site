# More header checks

```
~
  We can check if a header is what we expect using the header_name() function
  by passing the expected name as a second argument. The result is true or false.

  To add to the example, if we wanted to trigger an action based on the result
  of header_name() we could use a when/do expression based on one of two things:
    - A variable holding the value of header_name()
    - using header_name() in the when/do expression directly

  While you wouldn't typically use a variable in such a simple case, if you did
  you would need to remember that a variable standing by itself is an existance
  test. That means a variable with the value False is still True in the sense
  that it exists. To make the boolean value of the variable be used as its match
  vote you have to add the asbool qualifier.

  test-data: examples/headers/projects.csv
~
$[*][

    print("
Line: $.csvpath.line_number")

    @name = header_name(1, "compliance_project_name")
    @name.asbool -> print("    Name variable is correct: $.variables.name")

    @notname = header_name(1, "Compliance Project Name")
    not( @notname.asbool ) -> print("    Not name variable is also correct: $.variables.notname")

    header_name(1, "compliance_project_name") -> print("    Correct, no variable involved")
    not( header_name(1, "Compliance Project Name") ) -> print("    Also correct, still no variable involved")
]
```
