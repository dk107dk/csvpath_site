---
description: Forward your results from CsvPath's archive to an SFTP account
---

# Sending results by SFTP

<figure><img src="../../.gitbook/assets/sftp.png" alt="" width="100"><figcaption></figcaption></figure>

Sending your named-results files by SFTP easy. This feature is similar to the `transfer-mode` feature. The difference is that `transfer-mode` only copies files on the local disk.&#x20;

To start sending results by SFTP you simply:

* Make a trivial change to your `config/config.ini`
* Add metadata to the csvpath's external comments

The process is the same as for the other integrations. You will, of course, also need to have an SFTP account.&#x20;

{% hint style="success" %}
Sending results by SFTP as this page describes is not the same as using the SFTP backend. You have the option to [configure your archive, named-files, or named-paths storage areas to be in an SFTP server](../../topics/data-validation-files-and-storage/storage-backends.md). Doing that applies to all work in your CsvPath Framework project; whereas, sending results files the way this page describes is something you set up for an individual csvpath.
{% endhint %}

Here is the `config.ini` change:&#x20;

<figure><img src="../../.gitbook/assets/Screenshot 2025-01-08 at 9.16.41 PM.png" alt=""><figcaption></figcaption></figure>

If your project is new and you let `CsvPaths` generate it for you you just need to uncomment the `sftp.results` key and add `sftp` to the `groups` key. If you don't have the `sftp.results` key already, just paste in:

```ini
sftp.results = from csvpath.managers.integrations.sftp.sftp_sender import SftpSender
```

If you want a `CsvPaths` instance to generate a new config, move the old one to a temp file and just do either of the following. Bear in mind that this feature is at CsvPath point release `0.0.505` or greater.

```
poetry run cli    
```

Or if you're not a fan of Poetry, make a trivial Python file that has these two lines and run it:&#x20;

```python
from csvpath.cli import Cli
Cli().loop()
```

Next the metadata directives:

* sftp-server
* sftp-port&#x20;
* sftp-user&#x20;
* sftp-password&#x20;
* sftp-target-path&#x20;
* sftp-files&#x20;
* sftp-original-data

You can use these in external comments. External comments are ones that are above or below your csvpath, but not within the csvpath. Comments are delimited with the `~`. Obviously some of these values are required. Server, port, user, password, and sftp-files are mandatory.&#x20;

<figure><img src="../../.gitbook/assets/Screenshot 2025-01-10 at 3.34.59 PM.png" alt=""><figcaption><p>Notice the ALL CAPS env references and var|variable dynamic substitutions.</p></figcaption></figure>

| Setting              | Description                                                                                                                                                                                                                                                                 | Example                                                         |
| -------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------- |
| `sftp-server`        | The network name or IP of the  SFTP server.                                                                                                                                                                                                                                 | `sftp-server: localhost`                                        |
| `sftp-port`          | The port.                                                                                                                                                                                                                                                                   | `sftp-port: 22`                                                 |
| `sftp-user`          | This is the username of the regular SFTP account, not an admin account.                                                                                                                                                                                                     | `sftp-user: frog`                                               |
| `sftp-password`      | The account password. If the value is ALL CAPS it is swapped for the value of any env var that matches.                                                                                                                                                                     | `sftp-password: SFTP_USER_PASSD`                                |
| `sftp-target-path`   | The directory within the account where the files will land                                                                                                                                                                                                                  |                                                                 |
| `sftp-files`         | <p>A set of file names in the form X > Y, Z > A, B > C. </p><p></p><p>This pattern means that X will be copied to a file named Y, Z to a file named A, and so forth. </p>                                                                                                   | `sftp-files: data.csv > results.csv, errors.json > errors.json` |
| `sftp-original-data` | If `yes`, the original data file is sent using the same original filename. The original data file is taken from the first csvpath in the named-paths group. That way if we are in `source-mode: preceding`, or doing one of the by\_lines methods, we get the correct data. | `sftp-original-data: yes`                                       |

For all these settings you have two options for non-static values:&#x20;

* `ALL CAPS` are swapped for env vars, if there is a match
* Any value that is in the form `var|variablename` is swapped for any matching run variable named `variablename`. If none matches `variablename` becomes the value.&#x20;

