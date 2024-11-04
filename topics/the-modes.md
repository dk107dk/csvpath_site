# The Modes

A `CsvPath` instance can run in several possible modes that allow you to configure its behavior without resorting to the global `config.ini` or applying settings programmatically. In particular, the modes help you configure groups of csvpaths more flexibly. You can easily disable individual csvpaths or configure them differently than other csvpaths in the same named-paths group.&#x20;

Modes are set in your csvpath's comments. The modes are:&#x20;

* `run-mode` \[`run` / `no-run`]
* `validation-mode` _(any combination of)_
  * `print` / `no-print`
  * `raise` / `no-raise`
  * `stop` / `no-stop`
  * `fail` / `no-fail`
* `logic-mode` \[`AND / OR`]
* `return-mode` \[`matches` / `no-matches`]
* `print-mode` \[`default` / `no-default`]
* `explain-mode` \[`explain` / `no-explain`]

Modes are set in _external_ comments. External comments are comments that are outside the csvpath, above or below it. Comments can have other metadata and plain text mixed in with mode settings. When a setting is not explicitly made the default is:&#x20;

* `run-mode`: the csvpath is run
* `validation-mode`: validation errors are printed (note that `config.ini` raises exceptions by default,  the default behavior remains to raise exceptions)
* `logic-mode`: match components are ANDed
* `return-mode`: matches are returned
* `print-mode`: printing to the console is on
* `explain-mode`: no explanation is presented in INFO

These settings are configured like in this example of two trivial csvpaths in a named-paths group called `example`:

```bash
~
   id: hello_world
   run-mode: no-run
~
$[*][ yes() ]

---- CSVPATH ----

~  
   id: next please!
   explain-mode: explain
   validation-mode: no-raise, print
   logic-mode: OR
   return-mode: matches
   print-mode: default :
   All of these mode settings are optional, of course! And they don't have to be written as neatly as this, either.   
~
$[*][
   import($example.csvpaths.hello_world)
   yes()
]
```

`hello_world` will not be run when the named-paths group runs, but it will be imported into the second csvpath identified as `next please!`. This example doesn't do much, but it gives an idea of how you can easily configure individual csvpaths within a group that will be run as a single unit.

### Run Mode

<table><thead><tr><th width="200">Setting</th><th></th><th data-hidden></th></tr></thead><tbody><tr><td><code>no-run</code></td><td>The csvpath will not be run on its own. It only runs as an import into another csvpath that is runnable.</td><td></td></tr><tr><td><code>run</code></td><td>Run is the default.</td><td></td></tr></tbody></table>

### Validation Mode

Validation mode controls how the `CsvPath` instance reacts to built-in validation errors. Built-in validation errors have two types:&#x20;

* Problems with the csvpath's syntax or structure
* Problems with the data being validated

<table><thead><tr><th width="204">Setting</th><th></th><th data-hidden></th></tr></thead><tbody><tr><td><code>raise</code></td><td>The setting <code>raise</code> indicates that when a validation problem occurs, an exception should be raised that will likely halt the program. The opposite is <code>no-raise</code>. Setting neither value defaults the decision back to the global config.ini setting.</td><td></td></tr><tr><td><code>print</code></td><td>The <code>print</code> setting makes the <code>CsvPath</code> instance print validation messages to all configured Printer instances. The opposite is <code>no-print</code>.</td><td></td></tr><tr><td><code>stop</code></td><td>The <code>stop</code> mode setting makes the <code>CsvPath</code> instance stop as soon as a validation problem occurs. <code>no-stop</code> prevents this premature completion, enabling the <code>CsvPath</code> instance to alert and continue. </td><td></td></tr><tr><td><code>fail</code></td><td>The <code>fail</code> setting sets the csvpath being run to invalid. Effectively this means setting the <code>CsvPath</code> instance's <code>is_valid</code> property to <code>False</code>. The opposite setting is <code>no-fail.</code> Failing has no effect on the program or the validation run continuing.</td><td></td></tr></tbody></table>

### Logic Mode

<table><thead><tr><th width="201"></th><th></th><th data-hidden></th></tr></thead><tbody><tr><td><code>AND</code></td><td><code>AND</code> is the default logic mode. It requires that all match components evaluate to True for a line to match.</td><td></td></tr><tr><td><code>OR</code></td><td><code>OR</code> mode is similar to how the <code>or()</code> function works. Any match component that evaluates to true makes the line match.</td><td></td></tr></tbody></table>

### Return Mode

<table><thead><tr><th width="201">Setting</th><th></th><th data-hidden></th></tr></thead><tbody><tr><td><code>matches</code></td><td>All the matching lines will be returned by <code>next()</code> or <code>collect()</code>. (<code>fast_forward()</code> never returns lines, regardless of mode). This is the default behavior.</td><td></td></tr><tr><td><code>no-matches</code></td><td>All the lines that fail to match will be returned.</td><td></td></tr></tbody></table>

### Print Mode

<table><thead><tr><th width="196">Setting</th><th></th><th data-hidden></th></tr></thead><tbody><tr><td><code>default</code></td><td>When <code>default</code> is set the <code>CsvPath</code> instance prints to the console, as well as any other Printer instances you configure.</td><td></td></tr><tr><td><code>no-default</code></td><td>When <code>no-default</code> is set the standard console printer is disabled.</td><td></td></tr></tbody></table>

### Explain Mode

<table><thead><tr><th width="195">Setting</th><th></th></tr></thead><tbody><tr><td><code>explain</code></td><td>When set a step-by-step explanation of the values, assignments, match, etc. are dumped to INFO for each line in the file being processed. This can be a good aid to debugging but is performance expensive. The hit can be around 20-25%.</td></tr><tr><td><code>no-explain</code></td><td><code>no-explain</code> is the default.</td></tr></tbody></table>
