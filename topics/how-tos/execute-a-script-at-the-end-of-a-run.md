# Scripts

<figure><img src="../../.gitbook/assets/Screenshot 2025-03-31 at 6.51.04 PM.png" alt="" width="563"><figcaption><p>A script and its output captured to a timestamped file after a run is complete</p></figcaption></figure>

Running a script at the end of a named-paths group run is a common need. Setting it up is a straightforward configuration file change plus one `PathsManager` method call.

### Configuration

In `config/config.ini` you need a couple of things:&#x20;

* The listener enabled
* The `[scripts]` section with two keys

First, make sure you have the `[scripts]` section. If your `config.ini` file is newly generated from the most recent point release, it will be there. Otherwise, add it like this:

<figure><img src="../../.gitbook/assets/Screenshot 2025-03-31 at 6.54.42 PM.png" alt="" width="375"><figcaption></figcaption></figure>

The `run_scripts` key is enables or blocks all script running. By default script running is blocked. To run scripts you must have the value `yes`. The `shell` key is optional. CsvPath Framework uses it to create a shebang in the first line of your script if it doesn't see one. You can set `shell` to blank or remove the key, if you don't think it would be helpful.

You also need the listener import line at `[listeners] scripts.results`. Again, if your project is new you may have it. Otherwise, copy and paste from the code below.

Next, let's make sure the listener is active.&#x20;

<figure><img src="../../.gitbook/assets/Screenshot 2025-03-31 at 6.59.56 PM.png" alt=""><figcaption></figcaption></figure>

The listener group is `scripts`. There is only one event type that executes scripts: `results`. You need the `scripts.results` key under `[listeners]` to import the class. And you need the `groups` key to include `scripts`. If you have multiple listener groups enabled just remember to comma-separate them.  Here's everything:&#x20;

```ini
[listeners]
groups = scripts
scripts.results = from csvpath.managers.integrations.scripts.scripts_results_listener import ScriptsResultsListener
```

### Adding a script

To add a script you do one of:&#x20;

* Add the script to the named-paths groups `definition.json` in a text editor by hand
* Call the `PathsManager`'s `store_script_for_paths()` method

The second option is the better and easier choice. Using the `PathsManager` method you have less chance for error. If the definitions file doesn't yet exist it is generated for you. However, should you want to add the script by hand, you can.

### First, let's see the hard way&#x20;

* Open or create definitions.json wherever you keep your csvpaths prior to loading them. Your file doesn't need to be called `definitions.json`, but when you load it that is the name CsvPath Framework will use
* Create a `_config` key with a dict
* In the `_config` dict add a key with the named-paths group name that holds a dict
* In the dict add a script type key that holds a script name

The script type is one of:&#x20;

* `on_complete_all_script` — executed on every run
* `on_complete_valid_script` — executed when all csvpaths in the run are fully valid
* `on_complete_invalid_script` — executed when any csvpath in the run is invaid
* `on_complete_errors_script` — executed if there were any errors

What you get should look something like:&#x20;

```json
{
  "many": [
    "tests/test_resources/named_paths/many.csvpaths"
  ],
  "numbers": [
    "tests/test_resources/named_paths/zips.csvpaths",
    "tests/test_resources/named_paths/select.csvpaths"
  ],
  "needs split": [
    "tests/test_resources/named_paths/zips.csvpaths"
  ],
  "_config": {
    "many": {
      "template": ":1/:run_dir/:2",
      "on_complete_all_script": "complete_script.sh"
    }
  }
}
```

That's not super hard, but it's harder than doing it the easy way.&#x20;

You would then put your script file, in this example `complete_script.sh`, in the named-paths home, the same directory as the definition.json ends up.

### The easy way is better!

The easy way to add a script is to call a `PathManager` method:&#x20;

```python
from csvpath import CsvPaths

CsvPaths().paths_manager.store_script_for_paths(
    name="many", 
    script_name="complete_script.sh", 
    text="echo 'hello world'"
)
```

Here the named-paths group name is `many`. If we didn't want to run the script every time using `on_complete_all_script`, the default, we would add a parameter like `script_type="on_complete_errors_script"` or or one of the other script types.&#x20;

The outcome of the method call is the same as the example of doing it by hand — just much easier to set up.

### What happens?

When your named-paths group runs and the script type's condition is met, CsvPath Framework copies the script file into the run home directory and runs it. It captures the standard out and error out to a text file that has the same name as the script plus a timestamp.

And that's it.&#x20;

The only caveat is that you cannot run scripts after named-paths group runs unless you are using the local filesystem backend — the default. If you are storing your archive in the cloud or on an SFTP server you will need to use another method to trigger actions. [A cloud function](csvpath-in-aws-lambda.md) would be one option. You can [use Zapier, FTTT, or another webhook savvy tool with a named-paths webhook call](call-a-webhook-at-the-end-of-a-run.md) to trigger actions and workflows in the cloud.

