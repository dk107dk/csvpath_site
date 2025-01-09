---
description: Forward your results from the archive to an SFTP account
---

# Sending results by SFTP

Sending your named-results files by SFTP easy. This feature is similar to the `transfer-mode` feature. The difference is that `transfer-mode` only copies files on the local disk.&#x20;

To start sending results by SFTP you simply:

* Make a trivial change to your `config/config.ini`
* Add metadata to the csvpath's external comments

The process is the same as for the other integrations. You will, of course, also need to have an SFTP account.&#x20;

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

Next the metadata directives. There are just a few of them:

* sftp-server
* sftp-port&#x20;
* sftp-user&#x20;
* sftp-password&#x20;
* sftp-target-path&#x20;
* sftp-files&#x20;
* sftp-original-data

You can use these in external comments. External comments are ones that are above or below your csvpath, but not within the csvpath. Comments are delimited with the `~`. Obviously some of these values are required. Server, port, user, password, and sftp-files are mandatory.&#x20;

