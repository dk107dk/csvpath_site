# Counters

```
~
  This csvpath uses a decimal counter value to create a score for a
  developer based on how many projects they have.

  It also uses increment() to create a scaled impact metric based on
  a count of developer projects.

   id: developers
  test-data: examples/counting/projects.csv
~

$[1*][

     #developer == "The Druker Company LTD" -> counter.influence(6.35)

     increment.nocontrib.impact_scale(#developer == "The Druker Company LTD", 3)

     gte.nocontrib(@influence, 50) -> @msg = "Druker has influence: "
     lt.nocontrib(@influence, 50) -> @msg = "Druker has little influence: "

     last.nocontrib() -> @influence = round(@influence, 2)
     last.nocontrib() -> print("$.variables.msg $.variables.influence")

]
```
