---
description: Registering files from an SFTP server into a named-file
---

# Registering Files From SFTP

Like with HTTP(S), you can pull files to register from an SFTP server that is not a regular project storage backend. That gives you four sources of files to register into named-files:&#x20;

* The local filesystem (whether configured as one of the project's storage backends or not)
* Via [HTTP(S)](../storage-backends/https.md) from publically available URLs
* From any location in a [project backend provider](../storage-backends/) that is accessible to the account used for the backend
* From one of a set of arbitrary SFTP servers configured on a particular named-file

This page is about the last bullet.

#### Adding an SFTP To a Named-file

Like named-paths groups, named-files have definition.json files that hold configuration information, such as default templates and SFTP servers. When you add an SFTP server any registration that involves SFTP is first matched against the backend SFTP config in the form at Config > Integrations > SFTP in FlightPath Data or `[sftp]` in the project's `config.ini` file. If there is no match, the FileManager then looks for what are called `ServerConfig`s in the `description.json`.

A server config in a `definition.json` file is pretty straightforward (and simpler than for a named-path). It looks like this:&#x20;

```json
{
  "sources": {
    "myserver": {
      "address": "192.168.1.182",
      "port": 2022,
      "username": "david",
      "password": "myPassw0rd"
    }
  }
}
```

Even so, the easier way to create an SFTP definition is in FlightPath Data. To do it that way, first stage a named-file by right clicking on a file or folder in the project tree and using the Stage Data Dialog. Then right-click on the named-file and select `Set SFTP sources`. A dialog opens that lets you create a list of named SFTP servers. Enter your server's information, click the test button to confirm your config works, and click `Set`. Your `definition.json` will then include a block like the JSON shown above.

<figure><img src="../../../.gitbook/assets/Screenshot 2026-07-16 at 5.22.44 PM.png" alt="" width="563"><figcaption></figcaption></figure>

Based on the configuration above, when I attempt to register:&#x20;

```
sftp://192.168.1.182:2022/myfiles/geotags.csv    
```

CsvPath Framework will find the server in the config by matching on the address and port, grab the credentials, and do the registration into the named-file. And as a reminder, if you don't want to put your credentials in your definition.json files (good call!) you can add them as UPPERCASE project or OS environment variables and and use those uppercase names in the form. CsvPath Framework will see the uppercase-ness and look in the env variable location configured for the project for a variable with the same name.&#x20;
