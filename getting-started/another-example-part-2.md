# Another Example, Part 2

In this second part of the orders data file example we are going to modify our csvpath and its Python runner to be more automation and management friendly. &#x20;

First let's call out the requirements. What are we trying to achieve?

* Separate the code from the csvpath
* Break down the validation rules
* Give ourselves more options for reporting and error handling
* Set ourselves up for making references to other data for lookups

Let's say more.

#### Separate the code

Separating the code from the csvpath is straightforward. We don't want to colocate the csvpath in a Python variable. That constrains our formatting choices, complicates updates and the code, and makes the solution single use. We don't want to keep that physical file reference built into the csvpath, either. Our ideal root for our path is this:

```
$[*]
```

#### Componentize the csvpath rules

Secondly, having our six validation concerns in one file makes us work harder in development. With six rules you have to take all of them into account when you test your csvpath. Writing and testing one rule at a time, sepaately, is simpler. Our solution, ideally, should let us have six csvpaths that we can run and manage as a group.&#x20;

#### Capture print statements and errors

Third, printing validation messages is an excellent way to do data validation. This kind of reporting may seem simple, but simple is good. That said, could we wish for more control over the output? Sure. We might want to craft an email or some other kind of report. It would be nice to be able to do that without scraping the command line system out.&#x20;

Likewise with error handling. We'll test our csvpath, of course! But at runtime things happen. And keep in mind that the data may change—we don't control that. So we'd like error handling that is robust with outputs that are inspectable.&#x20;

#### References to other data

Finally, our csvpath doesn't currently refer to outside data, but it could. And, given what the data is, there is a strong possibility that in a real scenario we would want to check UPCs or company names, or other things against known-good values. To do that we need our references to be able to find other data sets. The way our script is currently set up, we can't do that.

&#x20;&#x20;
