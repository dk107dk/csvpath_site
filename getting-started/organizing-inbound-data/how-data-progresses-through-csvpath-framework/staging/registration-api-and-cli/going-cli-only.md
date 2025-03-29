# Going CLI-only

The CsvPath Framework's CLI is a great development and testing tool. It works without code in a local environment, enabling you to get projects started fast and iterate on your csvpath statements rapidly.

The CLI is not comprehensive. It supports references, but not the complete range of flexibility. It does not provide any support for templates; you would have to add those by editing JSON or using the API.&#x20;

[Read more about the CLI here](../../../../../topics/the-cli.md).

From Poetry just type `poetry run cli`. To start the CLI from Python do:

```python
from csvpath.cli.cli import Cli    
Cli().loop()
```

Or:

```python
python csvpath.cli.cli.py
```



<figure><img src="../../../../../.gitbook/assets/Screenshot 2025-03-29 at 1.51.14 PM.png" alt="" width="375"><figcaption><p>Poetry users, just type poetry run cli</p></figcaption></figure>

<figure><img src="../../../../../.gitbook/assets/Screenshot 2025-03-29 at 1.51.38 PM.png" alt="" width="375"><figcaption></figcaption></figure>

<figure><img src="../../../../../.gitbook/assets/Screenshot 2025-03-29 at 1.52.02 PM.png" alt="" width="306"><figcaption></figcaption></figure>

