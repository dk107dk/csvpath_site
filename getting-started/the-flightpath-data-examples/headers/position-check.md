# Position check

```
~
   Checking a header's position
   id: header name
   test-data: examples/headers/projects.csv
~
$[*][

    header_name("compliance_project_name") == 1 -> print("Position is correct!")
]
```
