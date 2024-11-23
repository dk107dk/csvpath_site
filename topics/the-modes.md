# The Modes

In the context of a `CsvPaths` instance's run, an individual `CsvPath` instance can operate in several possible modes that allow you to configure its behavior without resorting to the global `config.ini` or applying settings programmatically. In particular, the modes help you configure groups of csvpaths more flexibly. You can use them to easily disable individual csvpaths or configure them differently than other csvpaths in the same named-paths group.&#x20;

Modes are set in your csvpath's comments. The modes are:&#x20;

* `run-mode:` \[`run` / `no-run`]
* `validation-mode:` _(any combination of)_
  * `print` / `no-print`
  * `raise` / `no-raise`
  * `stop` / `no-stop`
  * `fail` / `no-fail`
* `logic-mode:` \[`AND / OR`]
* `return-mode:` \[`matches` / `no-matches`]
* `print-mode:` \[`default` / `no-default`]
* `explain-mode:` \[`explain` / `no-explain`]
* `unmatched-mode:` \[`keep` / `no-keep`]
* `files-mode:`&#x20;
  * `all`&#x20;
  * `data` / `no-data`&#x20;
  * `unmatched` / `no-unmatched`&#x20;
  * `printouts` / `no-printouts`&#x20;
* `transfer-mode:` `data` / `unmatched` `>` `var-name`

Modes are set in _external_ comments. External comments are comments that are outside the csvpath, above or below it. Comments can have other metadata and plain text mixed in with mode settings. When a setting is not explicitly made the default is:&#x20;

* `run-mode`: the csvpath is run
* `validation-mode`: validation errors are printed (note that `config.ini` raises exceptions by default,  the default behavior remains to raise exceptions)
* `logic-mode`: match components are ANDed
* `return-mode`: matches are returned
* `print-mode`: printing to the console is on
* `explain-mode`: no explanation is presented in INFO
* `unmatched-mode`: no lines that were not returned are kept&#x20;
* `files-mode`: always-present files are generated and others may or may not be with no consequence
* `transfer-mode`: there is no default

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
   unmatched-mode: keep
   print-mode: default :
   All of these mode settings are optional, of course! And they don't have to be written as neatly as this, either.   
~
$[*][
   import($example.csvpaths.hello_world)
   yes()
]
```

`hello_world` will not be run when the named-paths group runs, but it will be imported into the second csvpath identified as `next please!`. This example doesn't do much, but it gives an idea of how you can easily configure individual csvpaths within a group that will be run as a single unit. As you can see, some modes can take multiple values separated by commas.

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

### Unmatched Mode

<table><thead><tr><th width="206">Setting</th><th></th></tr></thead><tbody><tr><td><code>keep</code></td><td>Return mode determines if matches or non-matches are returned. Unmatched mode determines if the non-returned lines are kept available in the <code>Result</code> instance or on the <code>CsvPath</code> instance. If the lines are kept and you are using a <code>CsvPaths</code> instance, the <code>Result</code> instance will be serialized to the <code>archive</code> directory and you will see an <code>unmatched.csv</code> file containing the lines.</td></tr><tr><td><code>no-keep</code></td><td>No lines that were not returned are kept.</td></tr></tbody></table>

### Files Mode

The impact of `files-mode` is that the run instance manifest and the csvpath's manifest will show that files were created as expected, or not.&#x20;

There are various reasons why printouts.txt, data.csv and unmatched.csv might not be generated. For e.g., if we expect no validation output from user-created `print()` statements or built-in validation error messages we might set the `files-mode` to `no-printouts`. If a validation error was then printed we would be alerted in the metadata. In another example, if we set `unmatched-mode` to `no-keep` (the default) and `files-mode` to `unmatched` we have a conflict that we'll be alerted to in the metadata. Similarly, if we set `files-mode` to `data` and then run `fast_forward_paths()` we will not get `data.csv` files and the metadata will alert us to the mismatch.

`errors.json`, `vars.json`, `meta.json`, and `manifest.json` are always generated, regardless of `files-mode`. When you set `files-mode` to `all` the CsvPath Library will double-check that meta, vars, errors were correctly created, but that part of its checking is superfluous.

<table><thead><tr><th width="210">Setting</th><th></th></tr></thead><tbody><tr><td><code>all</code></td><td>All file types are expected to be generated</td></tr><tr><td><code>data</code> / <code>no-data</code></td><td>Determines if the data.csv file is expected</td></tr><tr><td><code>unmatched</code> / <code>no-unmatched</code></td><td>Determines if the unmatched.csv file is expected</td></tr><tr><td><code>printouts</code> / <code>no-printouts</code></td><td>Determines if we expect anything to be sent to the <code>Printer</code> instances using <code>print()</code></td></tr></tbody></table>

### Transfer Mode

transfer-mode let's you copy `data.csv` or `unmatched.csv` to an arbitrary location in the `transfers` directory. The `transfers` directory is configured in `config/config.ini` under `[results] transfers`. To use `transfer-mode` you use the form `data` | `unmatched` `>` _var-name_ where _var-name_ is the name of a variable that will be the relative path under the `transfer` directory to the data you are transferring. Note that `transfer-mode` has no effect on the original data, in keeping with CsvPath Library's copy-on-write semantics. You may have as many transfers as you like by separating them with commas.

<table><thead><tr><th width="209">Setting</th><th></th></tr></thead><tbody><tr><td><code>data</code> <code>></code> <em>var-name</em></td><td>Indicates you are transferring <code>data.csv</code> to the value of <em>var-name</em> as a relative path within the <code>transfer</code> directory</td></tr><tr><td><code>unmatched</code> <code>></code> <em>var-name</em></td><td>Indicates unmatched.csv to the value of var-name</td></tr></tbody></table>
