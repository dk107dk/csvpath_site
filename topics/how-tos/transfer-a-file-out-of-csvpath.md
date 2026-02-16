# File system transfers

Files in the Archive are intended to stay put until they age out or are otherwise administratively handled. A csvpath writer or DataOps engineer shouldn't be expecting to move files from the Archive to somewhere else. There are two main ways to handle this expectation:

* Copy files from the Archive using some automation, leaving the originals in place
* Use CsvPath's transfer function to direct a copy of a data file to an external location&#x20;

&#x20;Both approaches are fine, of course. This how-to is about the second one.&#x20;

A transfer copies a `data.csv` or `unmatched.csv` to a dynamically chosen location. These are the only files you can transfer. When you transfer a file you are copying the contents to another location, not moving it. The original file always stays where it is created in the run.

The way you do a transfer involves [setting a mode](../the-modes.md): `transfer-mode`. That's right, you set up transfers on a csvpath-by-csvpath basis. Transfer mode is like any of the modes. It is set in an external comment. An external comment is a comment that is above or below the csvpath, not within the match part of the path. Setting transfer mode looks like:

```xquery
~ 
id: transfer test
transfer-mode: data > my-file-var
~
$[*][yes()]
```

&#x20;What that `transfer-mode` value means is that you are going to copy the `data.csv` file from you csvpath instance's home directory to the path that is the value of the `my-file-var` variable. You can set `my-file-var` (or whatever you name the variable) statically or dynamically. Either way works fine. Here are two examples:

```
~ 
id: transfer test
transfer-mode: data > my-file-var
~
$[*][
    @my-file-var = "march/orders/update.csv"
]
```

or:

```
~ 
id: transfer test
transfer-mode: data > my-file-var
~
$[*][
    @my-file-var = concat( now("%M"), "/orders/update.csv")
]
```

Transfers always go to a location below a transfer directory. You set the root transfer directory in `config/config.ini` in the `[results]` section with a `transfers` key. For example,

```ini
[results]
archive= TinPenny_toys
transfers= /Users/tptuser/cvspath/projects/transfers
```

In our first variables example above, the full transfer path the `data.csv` file would be copied to would be:

```
/Users/tptuser/cvspath/projects/transfers/march/orders/update.csv
```

Files that are transferred can append an existing file. This can be useful if you are assembling data from a series of csvpaths. The first csvpath in the series might transfer its data.csv to an output.csv file in the transfer dir as a new file. A second csvpath, either in the same named-paths group or another named-paths group, could then append its data.csv or unmatched.csv to the same output.csv file. The way you do that is by appending a `+` to the variable name.

Let me sum up a few things to remember about `tranfer-mode`:

* It is a mode set in an external comment as `transfer-mode:`
* Transfer mode only handles `data.csv` and `unmatched.csv` — the data files — not any of the other printouts, errors, metadata, etc. files
* Transfer mode copies content to another file, it doesn't move the original
* The copy goes to a file under the transfer directory pointed to by the `transfers` key in `config/config.ini`
* Transfer mode supports all the storage backends &#x20;
* The file path within the transfer directory is set in the variable you named in your `transfer-mode` metadata
* You must populate the variable for transfer mode to work. You can do this statically in your csvpath. We expect that in many cases the value will be constructed dynamically.
* A `+` appended to the variable name means that the transfer should append to the file indicated, if it exists.

