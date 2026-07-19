---
description: CsvPath Framework listeners are easy to create and powerful
---

# Creating a Custom Listener

CsvPath Framework is very much event oriented in its core functions. It relies on listeners to track file registrations, collect errors, capture run results, and more. The listener groups it supports send data to SQL databases, webhooks, scripts, JSON files, and more. You can add a new listener, written by yourself, in just minutes. Here's how.

Listeners are managed in groups. Look in your `config/config.ini` file for the \[listeners] section. There is a `groups` key that takes a comma separated list. Each name in the list is a member of a set of listeners that interface in the same way for a common purpose. The members of the set each handle one type of event:&#x20;

* File registrations
* Named-paths group loads
* Run start by csvpath
* Run starts
* Run results
* Result serialization
* Errors&#x20;

Most of these are self-evident. Run starts are for the group as a whole; whereas, the run starts by csvpath statement are specific to members of a named-paths group that is running. The run results events are fired at the end of runs. The result serialization events are fired when an individual csvpath completes.

To create your own listener, you just:

* Create a subclass of `csvpath.managers.listener` `Listener`
* Implement the event handling method `def metadata_update(self, mdata: Metadata) -> None`
* Put your module file in a folder under the `<project>/config` directory
* Add your group name to `[listeners] groups`
* Add your listener's import value to a key in `[listeners]` that starts with the group name and a period and ends in one of `file`, `path`, `result`, `results`

At a super high level, that's all there is to it. A trivial listener that listens for file registrations looks like:&#x20;

```python
from csvpath.managers.listener import Listener
from csvpath.managers.metadata import Metadata
from csvpath.managers.files.file_metadata import FileMetadata

class DemoListener(Listener):

    def __init__(self, config=None, csvpaths=None):
        super().__init__(config=config)
        self._csvpaths = csvpaths

    def metadata_update(self, mdata: Metadata) -> None:
        if isinstance(mdata, FileMetadata):
            print(f"DemoListener: mdata: {mdata}")
```

And the `config.ini` setup looks like:&#x20;

```ini
[listeners]
groups = default,activation, demo
demo.file = from rc4_int.demo_listener import DemoListener
```

Where my project is called `rc4`, my folder for python files is `rc4/config/rc4_int`, and my listener group is named `demo`. What could be simpler?
