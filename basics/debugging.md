# Debugging Your CsvPaths

CsvPaths is a declarative rules-based path language. As such, creating csvpaths can be drop-dead easy for easy things. For more complex situations you will undoubtedly sooner or later come to a head-scratcher. You can of course run CsvPath in an IDE debugger. But what other options are there for gaining an understanding of what your csvpath is doing?&#x20;

Here are some ideas.

* [Logging Levels](debugging.md#logging-levels)&#x20;
* [Error Policy](debugging.md#error-policy)
  * Check the error collector
* [Emit JSON](debugging.md#emit-json)&#x20;
* [Stop Early](debugging.md#stop-early)
* [Create a simple test csvpath](debugging.md#create-a-simple-test-csvpath)&#x20;
* Advice
  * print() is your friend
  * Use the $.csvpaths.headers field
  * push() line-by-line indicators
  * Check counts vs. numbers
  * Were the variables frozen?
* Value Producers, Match Deciders and Side-effects
* Access the variables and metadata programmatically
* Parser’s AST in debug logging
* The source code

## Logging Levels

The obvious place to start is with the log. By default CsvPath logs to ./logs. That will probably not be ideal for production. You can easily reset it by changing config.ini. You also have the option to reset the path to config.ini when you create your instance. You could even populate the csvpath.util.config.CsvPathConfig instance programmatically. (You probably shouldn't, but you can!)&#x20;

Here's an example of the config showing all the log-related options.

<figure><img src="../.gitbook/assets/log-options.png" alt="" width="375"><figcaption></figcaption></figure>

As you can see you have logging and error options for CsvPath and CsvPaths. If you use CsvPaths you still use the settings for CsvPath for those instances that CsvPaths is managing.

The logging is, today, heavily focused on matching. That's where most of the complexity creeps in. You can see when matching starts, what the match structure is, how the match components behave and what their focus is — meaning are they value producers, match deciders, or side-effects. Lots of information.

<figure><img src="../.gitbook/assets/log-example.png" alt=""><figcaption></figcaption></figure>

## Error Policy

CsvPaths and CsvPath have a multi-setting error policy. If you need more information, or more or less run protection, you should have a look. The options are:&#x20;

* `raise` — reraises exception, at the risk of interrupting production processes
* `collect` — collects Error objects with the associated Exception&#x20;
* `stop` — stops the run, as if your csvpath called the `stop()` function. Keep in mind you are only stopping the CsvPath the error occurred in. If you are working in the context of a CsvPaths instance, CsvPaths will either:&#x20;
  * Continue by starting the next CsvPath, if any, if you are processing serially, or
  * If processing breadth-first, continue with the next CsvPath in the list of CsvPaths considering each line until the run completes or all CsvPaths enter the stopped state
* `fail` — indicate that the CSV file is invalid. This does not stop the run.
* `quiet` — handles the error quietly with minimal additional noise in the log, low information availability, and no threat to the continuance of the production runtime

You can activate multiple of these options at once. `quiet` and `raise` obviously don't go together.

Keep in mind that your errors are collected by default, but if you remove `collect` from the error policy your error collector will not keep them. `quiet` without `collect` is a recipe for losing information.&#x20;

## Emit JSON

The Matcher instance held by a CsvPath can output JSON for its match components. The match components are held as Expression instances in a list of expressions in the Matcher. To produce JSON you'll want to do something like:&#x20;

```python
csvpath.matcher.dump_all_expressions_to_json()
```

You can also explore the expressions like this:&#x20;

```python
for i, e in enumerate(csvpath.matcher.expressions):
    json = csvpath.matcher.to_json(e[0])
    print(f"JSON for expression[{i}] is {json}")
```

## Stop Early

You have a lot of control over how many lines and which lines CsvPath sees, as well as when to stop processing. Remember that you can have the scanner pick out just one line with something like:

```
$my_test.csv[7][ print("what the heck?") ]
```

Sometimes that's the simplifying condition that helps you see what's going on.  Likewise, `stop()`ing early can act as a kind of breakpoint leaving you with access to the variables, match components, etc.

## Create a simple test csvpath

This may seem like obvious advice. CsvPath provides good options for breaking down sizable validation into smaller steps with good separation but still runnable as a unit. When you hit a hard problem, try to isolate it in its own csvpath. You can run it with other csvpaths in CsvPaths or you can import() it into another csvpath like a component. Running in CsvPaths has the added benefit of allowing you to easily separate out the problem csvpath's print statements and errors.

Advice

* `print()` is your friend — if you've been leaning on debuggers rather than print statements lately you may feel like the debugger is the way to go. Try print as well. It is simpler than learning the CsvPath internals and provides access to [a large amount of metadata](the\_reference\_data\_types.md).&#x20;
* Use the $.csvpaths.headers field — headers change mid-file because CSV. You can dump the current headers using the headers reference in a print statement. You can dump the line to compare to the headers using the `print_line()` function.
* `push()` line-by-line indicators — consider using `push()` to push indicators, variables, headers, etc., into a stack variable, line by line. This can be a handy way of seeing how state progresses over a run.
* Check counts vs. numbers — one of the CSV file things you wouldn't think would be hard turns out to be harder than expected: counts vs. references. When you refer to a line or a header you are pointing to an item in a 0-based list. When you count something you are indicating how many times you've seen it, a 1-based counter. When we talk about match counts and line numbers, or even line counts and line numbers, we are talking about different kinds of things. Then there's the distinction between "physical" lines and "data" lines. The former are essentially a count of line feed characters in a series of bytes. The latter is a series of line feeds plus the content between them. And finally there is the problem of lines that have whitespace but no delimiters, as well as lines with too few or too many delimiters. Lines with a single space look blank to us. Technically they are a single header line containing whitespace. CsvPath takes pity on us and treats those as blanks, meaning non-data lines. You can inspect all these numbers in the line monitor. Do: `print(f"{csvpath.line_montor}")` &#x20;
* Were the variables frozen? CsvPath always calls any `last()` functions on the last line scanned or the end of the file. However, if the csvpath is not activated for that line because the line is empty and would usually be skipped, the `last()` functions still run, but in a restricted context. Their variables are frozen, including stacks and tracking values.&#x20;

Remember that matches and producing values are different and not transitive
