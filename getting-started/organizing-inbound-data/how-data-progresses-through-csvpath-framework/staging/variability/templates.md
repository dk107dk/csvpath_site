# Templates

We construct a named-file's folder organization using templates. Templates are completely optional. Obviously, if you don't need them, so much the better, don't use them. Regardless, here's how they work.

<figure><img src="../../../../../.gitbook/assets/Screenshot 2025-03-28 at 3.35.17 PM.png" alt=""><figcaption><p>Named-file templates turn arrival paths into named-file paths</p></figcaption></figure>

Templates consist of:

* Static text, for example: `/orders/`
* Placeholders in the form of a colon followed by an integer, representing a path segment from the original source file's landing path. For example: `:3` or `:5`&#x20;
* The token colon + filename. `:filename` is replaced by the name of the source file.

`:filename` is not mandatory, but if it is present — and it typically would be — it must come last. If you don't use a `:filename` you are telling CsvPath to register all inbound files registered as that named-file under the same physical filename, which is fine, but not the most common approach.

In the example above, we receive a file in an MFT server. Let's say the it is an SFTP server and the user is named `acme`. The `acme` account is for Acme Inc., an external data partner who sends us order information from their Plastics division on a monthly, quarterly, and annual basis.&#x20;

In this example, our CsvPath Framework staging area is called `staging`. (This is a configurable value; the default is `inputs/named_files`). And our named-file name is `Acme`.

For reasons that include keeping the file layout easy to read and easy for a Grafana system to monitor, we want a named-file organization that is a bit more than the default: `staging/Acme/<filenames>`.

To do this we create a template that is stored in the named-file `manifest.json`. Templates can change. Each changed template is stored with the name-file update when a new file is registered. When a template is changed the layout of the named-file becomes more complex, so we would suggest using 0 or 1 templates, and definitely not many. Keep in mind that CsvPath Framework is for automation, so registering files with a single template should be a natural fit.
