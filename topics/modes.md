# Modes

A CsvPath instance has several possible modes that allow you to configure its behavior without resorting to the global config.ini or programmatic changes. In particular, you can disable individual csvpaths or configure them differently than other csvpaths in the same named-paths group.&#x20;

The modes are:&#x20;

* `run-mode`
* `validation-mode`
* `logic-mode`
* `return-mode`
* `print-mode`

Modes are set in external comments. External comments are comments that are outside the csvpath, above or below it. Comments can have other metadata and plain text mixed in with mode settings. When a setting is not explicitly made the default is:&#x20;

* `run-mode`: the csvpath is run
* `validation-mode`: validation errors are printed
* `logic-mode`: AND
* `return-mode`: matches are returned
* `print-mode`: printing to the console is on

These settings are configured like in this example:

```xquery
~
   id: hello world!
   run-mode: no-run
   validation-mode: raise, stop, print, no-fail
   logic-mode: OR
   return-mode: matches
   print-mode: default :
   All of these mode settings are optional, of course! And they don't have to be written as neatly as this, either.
~
$[*][ yes() ]
```

### Run Mode

<table><thead><tr><th width="200">Setting</th><th></th><th data-hidden></th></tr></thead><tbody><tr><td><code>no-run</code></td><td>The csvpath will not run on its own. It can only run as an import into another csvpath that is runnable.</td><td></td></tr><tr><td><code>run</code></td><td>This is the default.</td><td></td></tr></tbody></table>

### Validation Mode

Validation mode controls how the CsvPath instance reacts to built-in validation errors. Built-in validation errors have two types:&#x20;

* Problems with the csvpath syntax or structure
* Problems with the data being validated

<table><thead><tr><th width="204">Setting</th><th></th><th data-hidden></th></tr></thead><tbody><tr><td><code>raise</code></td><td>The setting <code>raise</code> indicates that when a validation problem occurs, an exception should be raised that will likely halt the program. The opposite is <code>no-raise</code>. Setting neither value defaults the decision back to the global config.ini setting.</td><td></td></tr><tr><td><code>print</code></td><td>The <code>print</code> setting makes the CsvPath instance print validation messages to all configured Printer instances. The opposite is <code>no-print</code>.</td><td></td></tr><tr><td><code>stop</code></td><td>The <code>stop</code> mode setting makes the CsvPath instance stop as soon as a validation problem occurs. <code>no-stop</code> prevents this premature completion, enabling the CsvPath instance to alert and continue. </td><td></td></tr><tr><td><code>fail</code></td><td>The <code>fail</code> setting sets the csvpath being run to invalid. Effectively this means setting the CsvPath instance's <code>is_valid</code> property to <code>False</code>. The opposite setting is <code>no-fail.</code> Failing has no effect on the program or the validation run continuing.</td><td></td></tr></tbody></table>

### Logic Mode

<table><thead><tr><th width="214"></th><th></th><th data-hidden></th></tr></thead><tbody><tr><td><code>AND</code></td><td><code>AND</code> is the default logic mode. It requires that all match components evaluate to True for a line to match.</td><td></td></tr><tr><td><code>OR</code></td><td><code>OR</code> mode is similar to how the <code>or()</code> function works. Any match component that evaluates to true makes the line match.</td><td></td></tr></tbody></table>

### Return Mode

<table><thead><tr><th>Setting</th><th></th><th data-hidden></th></tr></thead><tbody><tr><td><code>matches</code></td><td>All the matching lines will be returned by <code>next()</code> or <code>collect()</code>. (<code>fast_forward()</code> never returns lines, regardless of mode). This is the default behavior.</td><td></td></tr><tr><td><code>no-matches</code></td><td>All the lines that fail to match will be returned.</td><td></td></tr></tbody></table>

### Print Mode

<table><thead><tr><th>Setting</th><th></th><th data-hidden></th></tr></thead><tbody><tr><td><code>default</code></td><td>When <code>default</code> is set the CsvPath instance prints to the console, as well as any other Printer instances you configure.</td><td></td></tr><tr><td><code>no-default</code></td><td>When <code>no-default</code> is set the standard console printer is disabled.</td><td></td></tr></tbody></table>

