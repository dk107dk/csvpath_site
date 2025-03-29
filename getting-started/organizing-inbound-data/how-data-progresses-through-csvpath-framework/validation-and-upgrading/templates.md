# Templates

As with named-files, a named-paths group can have a template. Named-paths templates are not used in the validation and upgrading assets area, though. They are used during named-path group runs to determine where to publish the results of the run.&#x20;

All run results go into the Archive. The Archive is the trusted publisher that downstream data consumers can rely on for trustworthy data. As we said in the earlier page about [how data is structured in the publishing area](../../the-three-data-spaces/trusted-publishing.md), we need flexibility to mirror current systems, complex business needs, and other factors. If you can use the default — a flat, shallow list of named-results folders — you should! That would be so simple. But if you need more organization in your results directories you need named-paths group templates to define what that structure looks like for the results of each different named-paths group.

Let's quickly recap. A template is a path model. It is used to dynamically create a path for a file. The template model looks like:&#x20;

```applescript
my-folder-name/:3/:0/another-folder/:run_dir/:1
```

This is a long template. Yours might be shorter. The colon-number tokens are references to path segments in the path the original source data file was loaded from. To be clear: that's not the named-file path, nor is it the named-file's SHA256-named data version file. It is the original path where the file landed and was loaded into CsvPath Framework from. In many cases, we're talking about a path within an MFT server, like an SFTP server or an S3 bucket.

Why do it that way? The assumption is that a sufficient minimum business context is reflected in where the file landed and we can use that to create a similar context in CsvPath Framework. In principle that might not be the case. You could imagine files with UUIDs for names and all their context information only available in the data inside. That happens, but it isn't common. Usually our data comes to us in files with meaningful names at filesystem locations that provide context. If needed, we can use that context for continuity and integration within CsvPath Framework.

Templates are applied to the location of results. They support the Trusted Publisher function so they are a contract between CsvPath Framework and the downstream consumer. We keep them with the named-paths group because the named-paths group is effectively what populates the Archive with results to share downstream.

Add a template like this:&#x20;

```python
from csvpath import CsvPaths
CsvPaths().paths_manager.add_named_path_from_directory(directory='./assets', name='orders', template=':2/:0/:run_dir'))
```

This method stores the template in the named-paths group's optional `definition.json` file, creating the file if needed. `definition.json` is a use-created assignment of csvpaths files to names. It also has a `_config` key holding a dictionary of named-path group names to configuration values, including templates.

If your named-path is already loaded and you don't want to reload it for some reason, you can do:&#x20;

```python
from csvpath import CsvPaths
CsvPaths().paths_manager.store_template_for_paths(name='orders', template='Acme/:1/orders/:0')
```

You can also provide a template when you run a named-path group against one or more named-files, overriding any preexisting named-path group template.&#x20;

```python
from csvpath import CsvPaths
CsvPaths().collect_paths(pathsname="orders", filename="quarterly-orders", template='orders/:1/EMEA/:0/:run_dir')
```

We'll meet templates again when we look at publishing data.

&#x20;
