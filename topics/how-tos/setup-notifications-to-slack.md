---
description: Send yourself notifications about CsvPath runs via Slack webhooks
---

# Setup notifications to Slack

<figure><img src="../../.gitbook/assets/Screenshot 2024-12-18 at 7.04.18 PM.png" alt="" width="563"><figcaption></figcaption></figure>



CsvPath can send alerts to Slack as run events happen. It looks basically like this:&#x20;

<figure><img src="../../.gitbook/assets/Screenshot 2024-12-18 at 8.09.16 AM.png" alt="" width="563"><figcaption></figcaption></figure>

To recap, there are five event types. Each event goes to listeners. CsvPath has its own listener that creates new or updated manifests. The types are:&#x20;

* **Named-file staging**: a `file` event is fired at the time you add a file to the file inputs directory using the file manager.
* **Named-paths loading**: a `paths` event is fired when you load a named-paths group into the inputs directory using the paths manager.&#x20;
* **Run start**: when a run starts a `run` notification indicates the highest level inputs and start time. This event is fired whenever a named-path is started, so it is at the same point as a result event, but with the flatter, broader intent of telling you that an activity in the archive is happening.&#x20;
* **Results available**: `results` events are fired when at the beginning and end of a named-paths group run. It is summary-level information about the group's progress.
* **Result available**: a result `event` is fired when an instance of a csvpath in a named-paths group starts or completes. This is the most detailed event.

All of these events are received by all listeners configured in `config/config.ini` to listen for events of a type. For example, the Marquez OpenLineage listeners are configured like this:

```ini
marquez.file = from csvpath.managers.files.file_listener_ol import OpenLineageFileListener
marquez.paths = from csvpath.managers.paths.paths_listener_ol import OpenLineagePathsListener
marquez.result = from csvpath.managers.results.result_listener_ol import OpenLineageResultListener
marquez.results = from csvpath.managers.results.results_listener_ol import OpenLineageResultsListener
```

There is a Slack listener that can receive any of those same four events. (Neither Marquez or Slack support the very general `run` event). To configure Slack you simple add any or all of these lines to your `config.ini` file:

```ini
slack.file = from csvpath.managers.integrations.slack.sender import SlackSender
slack.paths = from csvpath.managers.integrations.slack.sender import SlackSender
slack.result = from csvpath.managers.integrations.slack.sender import SlackSender
slack.results = from csvpath.managers.integrations.slack.sender import SlackSender
```

You will also need to add or update a `[slack]` section to say what webhook you want the events to go to. That looks like this:&#x20;

```ini
[slack]
# add your main webhook here. to set webhooks on a csvpath-by-csvpath basis add
# on-valid-slack: webhook-minus-'https://' and/or
# on-invalid-slack: webhook-minus-'https://'
webhook_url =
```

Obviously you need to add your webhook URL.&#x20;

And finally you need to tell CsvPath that you want the `slack` group of event listeners to receive events. Do that by adding slack to the groups key in the `[listeners]` section of `config.ini`.

```ini
[listeners]
groups = slack, marquez
```

As the comments in your config file say, you can also configure the result Slack events on a csvpath-by-csvpath basis. Only the `result` events can be configured by a csvpath. That is because a `result` event is tied to a single csvpath; whereas, the other events apply to named-paths groups of csvpaths or to input files.

Within your csvpath you need an external comment. An external comment is one that is above or below the csvpath, not within the match part of the csvpath. In the external comment you may use one or both of the custom metadata fields that the Slack integration knows to look for:

* `on-valid-slack:`
* `on-invalid-slack:`

The value of the field is a webhook URL. When you add these fields remember to only give the URL starting with the subdomain and domain. So rather than:&#x20;

```url
https://hooks.slack.com/services/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
```

You just use:&#x20;

```xquery
~
id: Slack example
on-valid-slack: hooks.slack.com/services/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
~
```

The reason to use the shorter form is because a full URL has a protocol signifier that includes a colon. Since CsvPath metadata fields are defined as names followed by a colon, `https://...` looks to CsvPath like a metadata field named `https`.

If neither of these metadata fields is present, your event will go to the default URL in `config/config.ini`. As you would guess, if your csvpath is valid — per the `valid` field in the metadata collected during the run — the `on-valid-slack` webhook is called. If not `valid` the `on-invalid-slack` webhook gets the call. &#x20;

And in case you don't remember, you set the `valid` value using the `fail()` function. A csvpath is considered valid by default. Under certain circumstances it may have indications that something is wrong (e.g. the expected files not generated and stopped early indicators) which generally you see in the metadata and/or as errors in `errors.json`. But unless you explicitly say a file is invalid, it is valid. That said, bear in mind that built-in validations, when tripped, can mark a file as invalid. For example, if you try to `add("five", none())` you will raise an error and depending on your [mode settings](../the-modes.md), your file may be marked invalid without you having to do anything.
