# Named-paths Reference Queries

## How are references used?

References are used to run individual csvpaths or subsets of csvpaths in named-paths groups. For named-paths references their form is: &#x20;

```xquery
$root.csvpaths.name_one.name_two
```

The four sections are:

* Root: a named-file name, named-path name, or named-result name
* `csvpaths`: the datatype that indicates we are working with named-paths
* `name_one`: the most important id/name/date, etc. we're pointing to (`name_one` is the underlying name of this field, but you won't see it too often)
* `name_three`: a secondary id/name/date, etc. that helps determine what the reference is to&#x20;

{% hint style="warning" %}
References from CsvPath Validation Language that pick out variables from other runs are a case where you can use a # to point to variables from a specific csvpath instance in the  other results, or even an earlier csvpath instance in the currently running results.

A reference of this type might look like:&#x20;

```
$mypaths#myinstance.variables.city
```

This reference says to pull the value of the `city` variable from the `myinstance` csvpath variables from the most recent `mypaths` named-results run.  If you didn't use `#myinstance` you would be pulling the `city` variable from the union of all the variable sets created in the most recent run of `mypaths`. Since two csvpath instances might both leave behind their own `city` variable with a different value you might want to be more specific. &#x20;
{% endhint %}

Like named-file references, named-paths references use "pointers". A pointer looks like a colon followed by a word or number. Pointers enable dynamic references. For named-paths, the pointers are:&#x20;

* `:from` — used to indicate a run should start from a certain csvpath
* `:to` — like `:from`, but indicating the run should stop with a certain csvpath
* `:n` _(n = any integer from `0` to `99`)_ — indicates which csvpath to return from the group

{% hint style="danger" %}
As noted above, in some few cases you can split the root, name\_one, and name\_three path segments using a `#`. In fact, grammatically, you can always do this; however, the support for `#` separated words having a good effect is inconsistent and the intended usage has not yet settled.&#x20;

You might see the values created by a `#` referred to as `root_minor` and `name_two` and `name_four`.

But again, it is not common. Unless directions say to use the capability, you should not.
{% endhint %}

## Examples

Named-paths references are simple. They only need to give dynamic control over which csvpaths within the named-paths group to run. A named-paths reference does that by using the :from and :to pointers to indicate the starting or stopping csvpaths. If there is no pointer the reference is to the specific csvpath named. You can refer to a specific csvpath by name or by a colon-number pointer.

```
$invoices.csvpaths.cleanup:from
```

This reference says to do a run of the `invoices` named-paths starting from the `cleanup` csvpath. Or, to be more precise, it references the specific csvpath statements — but that typically means we're setting up a named-paths group run. It is, of course, equally easy to pass a reference to `PathsManager.get_named_paths()` and get back a list of the csvpath statements.&#x20;

Let's say that the invoices named-paths looks like:&#x20;

```bash
~ id: print date ~
$[0][ @day = today() print("Today is $.variables.day")]
---- CSVPATH ----
~ id: cleanup ~
$[*][ replace(#city, uppercase(#city)) ] 
---- CSVPATH ----
~ id: add line number ~
$[*][ append("line", line_number())] 
```

The reference would run the second (`cleanup`) and third (`add line number`) csvpaths in the group. The `print date` csvpath would not run.

```
$invoices.csvpaths.cleanup:1
```

Using the same example, this reference would return only the second csvpath from the `invoices` named-paths group.&#x20;

```
$invoices.csvpaths.cleanup:to
```

And finally, this version of the reference would run the first csvpath (`print date`) and the second (`cleanup`), but would not run the third csvpath in the group.
