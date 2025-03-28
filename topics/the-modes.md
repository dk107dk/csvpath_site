# The Modes

In the context of a `CsvPaths` instance's run, an individual `CsvPath` instance can operate in several possible modes that allow you to configure its behavior without resorting to the global `config.ini` or applying settings programmatically. In particular, the modes help you configure groups of csvpaths more flexibly. You can use them to easily disable individual csvpaths or configure them differently than other csvpaths in the same named-paths group.&#x20;

Modes are set in your csvpath's comments. The modes are:&#x20;

* [`error-mode`](the-modes.md#error-mode): \[`bare` / `full`]
* [`explain-mode`](the-modes.md#explain-mode)`:` \[`explain` / `no-explain`]
* [`files-mode`](the-modes.md#files-mode)`:` _(all or any combination of)_
  * `all`&#x20;
  * `data` / `no-data`&#x20;
  * `unmatched` / `no-unmatched`&#x20;
  * `printouts` / `no-printouts`&#x20;
* [`logic-mode`](the-modes.md#logic-mode)`:` \[`AND` / `OR`]
* [`print-mode`](the-modes.md#print-mode)`:` \[`default` / `no-default`]
* [`return-mode`](the-modes.md#return-mode)`:` \[`matches` / `no-matches`]
* [`run-mode`](the-modes.md#run-mode)`:` \[`run` / `no-run`]
* [`source-mode`](the-modes.md#source-mode)`:` `preceding`
* [`transfer-mode`](the-modes.md#transfer-mode)`:` `data` / `unmatched` `>` `var-name`
* [`unmatched-mode`](the-modes.md#unmatched-mode)`:` \[`keep` / `no-keep`]
* [`validation-mode`](the-modes.md#validation-mode)`:` _(any combination of)_
  * `print` / `no-print`
  * `raise` / `no-raise`
  * `stop` / `no-stop`
  * `fail` / `no-fail`
  * `collect` / `no-collect`
  * `match` / `no-match`

Modes are only set in _external_ comments. External comments are comments that are outside the csvpath, above or below it. External comments can also have other user-defined metadata and plain text mixed in with mode settings. If a mode setting is followed by plain text there must be a stand-alone colon between the mode and the text.&#x20;

## Defaults

When a mode is not explicitly set CsvPath uses sensible defaults. Some modes default to options set in `config/config.ini`. For example, `validation-mode` overrides `[errors] csvpath` in `config.ini`. ([Read here for more about the config file](../getting-started/how-tos/config-setup.md).) Other defaults are built-in, for instance, `logic-mode` overrides the library's built-in default matching using ANDed operations. The defaults are:&#x20;

* `error-mode`: defaults to `bare`, meaning `error()` and built-in errors are presented minimally
* `explain-mode`: no explanations are logged when logging is set to `INFO`
* `files-mode`: there is no check for optional files having been generated&#x20;
* `logic-mode`: match components are ANDed
* `print-mode`: print statements go to the console
* `return-mode`: matches are returned
* `run-mode`: the csvpath is run
* `source-mode`: the named-file that was passed to the named-paths group is used as input
* `transfer-mode`: no result data transfer is made
* `unmatched-mode`: the lines not returned are discarded&#x20;
* `validation-mode`: validation errors are only printed and logged&#x20;

## An Example

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

## Detailed Descriptions

### Run Mode

<table><thead><tr><th width="200">Setting</th><th></th><th data-hidden></th></tr></thead><tbody><tr><td><code>no-run</code></td><td>The csvpath will not be run on its own. It only runs as an import into another csvpath that is runnable.</td><td></td></tr><tr><td><code>run</code></td><td>Run is the default.</td><td></td></tr></tbody></table>

### Validation Mode

Validation mode controls how the `CsvPath` instance reacts to built-in validation errors. Built-in validation errors have two types:&#x20;

* Problems with the csvpath's syntax or structure
* Problems with the data being validated

<table><thead><tr><th width="204">Setting</th><th></th><th data-hidden></th></tr></thead><tbody><tr><td><code>raise</code></td><td>The setting <code>raise</code> indicates that when a validation problem occurs, an exception should be raised that will likely halt the program. The opposite is <code>no-raise</code>. Setting neither value defaults the decision back to the global config.ini setting.</td><td></td></tr><tr><td><code>print</code></td><td>The <code>print</code> setting makes the <code>CsvPath</code> instance print validation messages to all configured Printer instances. The opposite is <code>no-print</code>.</td><td></td></tr><tr><td><code>stop</code></td><td>The <code>stop</code> mode setting makes the <code>CsvPath</code> instance stop as soon as a validation problem occurs. <code>no-stop</code> prevents this premature completion, enabling the <code>CsvPath</code> instance to alert and continue. </td><td></td></tr><tr><td><code>fail</code></td><td>The <code>fail</code> setting sets the csvpath being run to invalid. Effectively this means setting the <code>CsvPath</code> instance's <code>is_valid</code> property to <code>False</code>. The opposite setting is <code>no-fail.</code> Failing has no effect on the program or the validation run continuing.</td><td></td></tr><tr><td><code>match</code></td><td>When <code>match</code> is set a built-in validation error will match, rather than fail to match. The thing to remember is that this setting applies to errors in the data (e.g. adding <code>"five"</code>, not <code>5</code>) only. Errors in the CsvPath Language are still not allowed. As a practical example <code>add("five", 5)</code> never works, but <code>add(@five, 5)</code> always does because even if <code>@five</code> turns out to not be a number on a particular line we still match on it in accordance with this setting. Regardless of if you set <code>match</code> or not, if you don't have <code>no-raise</code>, your csvpath will blow-up on validation errors.</td><td></td></tr><tr><td><code>collect</code></td><td>When <code>collect</code> is set errors are captured. When <code>no-collect</code> is set they are dropped. You can drop errors and still fail a file to make it invalid; just as you can capture errors but choose to not use <code>fail()</code>. Keep in mind that when you don't collect errors <code>CsvPath.has_errors()</code> is <code>False</code>. Also bear in mind that if you are using the <a href="../getting-started/getting-started-with-csvpath-+-opentelemetry.md">OpenTelemetry integration</a> (e.g. to push events to Grafana, New Relic, etc.) you can choose to drop errors but still fire error events. </td><td></td></tr></tbody></table>

### Logic Mode

<table><thead><tr><th width="201"></th><th></th><th data-hidden></th></tr></thead><tbody><tr><td><code>AND</code></td><td><code>AND</code> is the default logic mode. It requires that all match components evaluate to True for a line to match.</td><td></td></tr><tr><td><code>OR</code></td><td><code>OR</code> mode is similar to how the <code>or()</code> function works. Any match component that evaluates to true makes the line match.</td><td></td></tr></tbody></table>

### Return Mode

<table><thead><tr><th width="201">Setting</th><th></th><th data-hidden></th></tr></thead><tbody><tr><td><code>matches</code></td><td>All the matching lines will be returned by <code>next()</code> or <code>collect()</code>. (<code>fast_forward()</code> never returns lines, regardless of mode). This is the default behavior.</td><td></td></tr><tr><td><code>no-matches</code></td><td>All the lines that fail to match will be returned.</td><td></td></tr></tbody></table>

### Print Mode

CsvPath supports printing errors and user-defined messages to any number of `Printer` objects using the `print()` and `error()` functions. Printers send text to separate queues. By default a "standard out" printer is enabled that prints to the console, as well as to a file. If you don't want anything printed to the console you would set `no-default`.

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

### Source Mode

Usually the data for a csvpath in a named-paths group comes from the data input for the whole group. I.e., all the csvpaths in the group run against the same source file. However, in some cases you might want the input to a csvpath to be the csvpath preceding it. Meaning that the results captured from the first csvpath are piped into the second. To do this, you set `source-mode: preceding` on the second csvpath.

Keep in mind that `CsvPaths` instances' `_collects` methods and `_by_line` methods are [quite different in how they handle data sources](serial-or-breadth-first-runs.md). Source mode does not apply to by-lines runs—i.e. it is for linear, not breadth-first runs—because in a by-lines run each line is passed through each of the csvpaths in the named-paths group before the next line is considered. Csvpaths in a by-lines run can change data for downstream csvpaths in their named-paths group, and they can skip or advance the run in order to filter data so that downstream csvpaths don't have a chance at it. This just means that there are multiple ways of allowing earlier csvpaths to have an effect on later csvpaths.

[Source mode has a lot to do with rewind/replay](../getting-started/how-tos/file-references-and-rewind-replay-how-tos/doing-rewind-replay-part-1.md), also [references between data sets](../getting-started/how-tos/file-references-and-rewind-replay-how-tos/replay-using-references.md), as well as [strategies for validation and canonicalization](validation/validation_strategies.md).

| Setting     |                                                                                                              |
| ----------- | ------------------------------------------------------------------------------------------------------------ |
| `preceding` | Instructs the csvpath to use the output of the preceding csvpath in the named-paths group as its input data  |

### Transfer Mode

`transfer-mode` let's you copy `data.csv` or `unmatched.csv` to an arbitrary location in the `transfers` directory. The `transfers` directory is configured in `config/config.ini` under `[results] transfers`. To use `transfer-mode` you use the form `data` | `unmatched` `>` _var-name_ where _var-name_ is the name of a variable that will be the relative path under the `transfer` directory to the data you are transferring. Note that `transfer-mode` has no effect on the original data, in keeping with CsvPath Library's copy-on-write semantics. You may have as many transfers as you like by separating them with commas. [Read more about using transfer-mode here](../getting-started/how-tos/transfer-a-file-out-of-csvpath.md).

<table><thead><tr><th width="209">Setting</th><th></th></tr></thead><tbody><tr><td><code>data</code> <code>></code> <em>var-name</em></td><td>Indicates you are transferring <code>data.csv</code> to the value of <em>var-name</em> as a relative path within the <code>transfer</code> directory</td></tr><tr><td><code>unmatched</code> <code>></code> <em>var-name</em></td><td>Indicates unmatched.csv to the value of var-name</td></tr></tbody></table>

### Error Mode

`error-mode` allows you to output errors with log-like information or as plain plain messages.

<table><thead><tr><th width="220">Setting</th><th></th></tr></thead><tbody><tr><td><code>bare</code></td><td>Errors are output as simple strings</td></tr><tr><td><code>full</code></td><td><p>Errors are output according to the <code>[errors] pattern</code> config value using the following fields: </p><ul><li><code>time</code>: Time</li><li><code>file</code>: Named-file name</li><li><code>line</code>: Line number</li><li><code>paths</code>: Named-paths name</li><li><code>instance</code>: Csvpath instance ID/name</li><li><code>chain</code>: Match component chain</li><li><code>message</code>: Message</li></ul><p>The default pattern is: </p><p><code>{time}:{file}:{line}:{paths}:{instance}:{chain}: {message}</code> </p><p></p><p>The <code>chain</code> field gives the parent-child relationships from the top match component to the match component child that was the source of the error. </p></td></tr></tbody></table>

