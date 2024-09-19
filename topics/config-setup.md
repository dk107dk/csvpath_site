---
description: >-
  Configuring CsvPaths is easy. The first step is adding it to your project
  using your Python dependency management tool of choice. Then create a simple
  test harness file and run it.
---

# Config Setup

```
from csvpath import CsvPath
path = CsvPath()
```

CsvPath will create a config directory and a logs directory. Logs will be empty until you run CsvPath. The config directory will have the default config.ini file. The default config file has sensible defaults.&#x20;

If you want to move your config to another location, simply add the other location to the default config file as path.

<figure><img src="../.gitbook/assets/config-path.png" alt="" width="375"><figcaption></figcaption></figure>

Once you do that, you can clear out any other configuration values. Or you can leave them. Either is fine.&#x20;

When you start CsvPath it will check to see if it should load your config from another location. It will find the location in an env variable or in the path key in the default config.ini.

<figure><img src="../.gitbook/assets/config.png" alt=""><figcaption></figcaption></figure>

