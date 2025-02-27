# Add a file by https

You can register named-file content using HTTP or HTTPS in the same way that you would using S3, SFTP, or the local filesystem.&#x20;

While adding files by HTTP is a snap, the remote file name in the URL may not be helpful. CSV and Excel files on the web sometimes come out of applications. When they do they may lack a regular file name. Luckily there's an easy way to update the registered content with a name.

## Happy path

First, let's create a simple harness. Our goal is to register a file from the web in CsvPath Framework. We are importing it, or staging it, as a named-file. For context we'll run a csvpath against our new content and access the results.&#x20;

{% code lineNumbers="true" %}
```python
from csvpath import CsvPaths

class Main:
    def load_http_content(self):
        paths = CsvPaths()
        paths.file_manager.add_named_file(
            name="orders",
            path="https://drive.google.com/uc?id=1zO8ekHWx9U7mrbx_0Hoxxu6od7uxJqWw&export=download",
        )
        paths.paths_manager.add_named_paths(name="http_demo", paths=["$[*][yes()]"])
        paths.collect_paths(pathsname="http_demo", filename="orders")
        results = paths.results_manager.get_named_results("http_demo")
```
{% endcode %}

The main event is the method call starting on line 6 that adds a named-file called `orders`. The new version of `orders` is coming from a Google Drive account with a long opaque HTTPS URL. So far so good.&#x20;

## Let's fix that name

However, when we look at the registered file's manifest there is a gotcha. Our manifest is at `./inputs/named_files/orders/manifest.json`. (If you aren't using the default location for named-files your path will be different). When we open it we see:&#x20;

<figure><img src="../../.gitbook/assets/Screenshot 2025-02-27 at 9.11.23 AM.png" alt="The named-file manifest for a new item of CSV content."><figcaption></figcaption></figure>

Lots of things went right. Our time, uuid, from URL, and fingerprint are fine. But the file type should be `csv` and the file name and file home are garbled because the HTTP URL didn't point to a physical file so much as identify an item of content held by the Google Drive application.&#x20;

Since we know the data we're downloading is CSV data and we know what it is about, we can easily update the named-file to add clarity. We'll use the `patch_named_file` method. The `patch_named_file` method is on `FileRegistrar`. The `FileManager` that you use to add a named-file has a registrar to keep track of file metadata. It can help us easily compensate for HTTP's deficiencies.&#x20;

{% code lineNumbers="true" %}
```python
from csvpath import CsvPaths

class Main:
    def load_http_content(self):
        paths = CsvPaths()
        paths.file_manager.add_named_file(
            name="orders",
            path="https://drive.google.com/uc?id=1zO8ekHWx9U7mrbx_0Hoxxu6od7uxJqWw&export=download",
        )
        paths.file_manager.registrar.patch_named_file(
            name="orders", patch={"type": "csv", "file_name": "download.csv"}
        )
        paths.paths_manager.add_named_paths(name="http_demo", paths=["$[*][yes()]"])
        paths.collect_paths(pathsname="http_demo", filename="orders")
        results = paths.results_manager.get_named_results("http_demo")
```
{% endcode %}

The fix is line 10. We're passing a "patch" that will change the type of the file to `cvs` and the name of the file to `download.csv`. The `FileRegistar` updates the `manifest.json` so everything tics and ties. This is what you should see:

<figure><img src="../../.gitbook/assets/Screenshot 2025-02-27 at 9.22.07 AM.png" alt=""><figcaption></figcaption></figure>

And you're good. The `orders` named-file is ready to work.&#x20;

Of course using HTTP to load content into a named-file doesn't always require the extra step to patch it. If you have a URL like `https://csvpath.org/my-data-file.csv` you won't need to help CsvPath know what the file name and file type are because it's obviously CSV data in a file called `my-data-file.csv`. But if you do need to make an adjustment, that's how you do it.
