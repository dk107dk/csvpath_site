---
description: CsvPath Framework stretches OpenLineage all the way from edge to core
---

# OpenLineage



OpenLineage producers capture lineage events as they happen and send them to OpenLineage Consumers, like [DataHub](https://datahub.com/), [DataDog](https://www.datadoghq.com/dg/monitor/data-streams-monitoring/), [Marquez](https://marquezproject.ai/), among others. While manual or generated documentation of lineage patterns is valuable, OpenLineage events are ground-truth about how data is produced and consumed.

<figure><img src="../../../.gitbook/assets/Screenshot 2026-10-10 at 2.03.52 AM.png" alt="A simple csvpath pipeline in Marquez"><figcaption></figcaption></figure>

{% hint style="success" %}
The interoperability of CsvPath Framework events is tested against DataHub, Marquez, DataDog and a few others. For more screenshots from some of these tools [check below](./#screenshots-of-openlineage).
{% endhint %}

&#x20;

CsvPath Framework is an OpenLineage producer. The Framework fires OpenLineage events from built-in event handlers that you run by setting your `config.ini` file's `[listeners] group` to include `openlineage`.&#x20;

```
[listeners]
groups = openlineage
```

When you add the `openlineage` group you activate the following event handlers:

* **file** — fires when data is registered under a named-file
* **paths** — fired when a CsvPath Validation Language or ODCS file is loaded to a named-paths group
* **results** — fired by running a named-paths group against a registered data item
* **result** — fires once for each validation rule in the named-paths group&#x20;

The listeners are configured by default. You simply add the `openlineage` group to switch them on.&#x20;

{% hint style="info" %}
If you use FlightPath Data, open the Config Panel by clicking the config button at the bottom left. Then click on Integrations in the vertial tabs. In the Integrations tab click the OpenLineage link and see that the openlineage group is added to the groups.
{% endhint %}

### Configuration

All OpenLineage configurations are in `config.ini` under the `[openlineage]` section. The `config.ini` file is typically at `config/config.ini` of your working directory, or in the config folder of your FlightPath Data or FlightPath Server project.

There are two version of OpenLineage support in CsvPath. Version 1 works well with Marquez and remains available. Version 2 is the default and has improvements that include:

* Greater flexibility in names and namespacing&#x20;
* More facets and better use of the standard facets&#x20;
* Support for transfers as first-class output datasets

New projects should always use the v2 support. This page is only about v2. The v1 page is [here](openlineage-with-marquez-v1-2024.md).

To chose the version set the version key in the config.ini openlineage section:&#x20;

```ini
[openlineage] 
version = 2
```

Basic connection information is handled like this:&#x20;

```ini
base_url = http://localhost:5000
endpoint = api/v1/lineage
api_key = "none"
timeout = 3
verify = False
urlencode = False
gzip = 
retries = 0
```

Each OpenLineage consumer will have different requirements. The endpoint address isn't always the same, you can run some without an API key, others don't support gzip payloads. See your vender's documentation.&#x20;

Remember that you can use values in _ALL\_CAPS_ to reference OS environment variables or project environment variables set in a project's `env.json`. I.e. if `my api_key = MY_KEY` CsvPath Framework would attempt to resolve that to the value of a `MY_KEY` OS or project env var.

### Names and Namespacing

To see OpenLineage working, you only need the configuration above. But to see OpenLineage working for you in your environment tracking your data, you need to pay attention to naming.

The rest of this page is about OpenLineage configuration for interoperable names and namespacing.&#x20;

In order for your lineage events to tie into upstream and downstream systems, the names and namespaces must match. CsvPath Framework, as an edge data firewall, has to match its downstream data consumers. You can use the sensible defaults, but if your lake or warehouse doesn't recognize the names it defeats the purpose because your data's lineage will be broken.

The naming configuration keys are:&#x20;

```ini
namespace_prefix = csvpath
namespace_pattern = {prefix}.{root_path_separated}
path_separator = .

job_register_verb = register
job_load_verb = load
job_run_verb = run_group
job_run_instance_verb = run_instance

job_register_entity = {verb}{sep}{entity}
job_register_output = {entity}
job_register_manifest = {entity}{sep}manifest
job_load_entity = {verb}{sep}{entity}
job_load_output = {entity}
job_load_manifest = {entity}{sep}manifest
job_run_entity = {verb}{sep}{entity}
job_run_manifest = {entity}{sep}manifest
job_run_instance_entity = {verb}{sep}{entity}{sep}{instance}
job_run_instance_output = {entity}{sep}{instance}{sep}{file}
job_run_instance_manifest = {entity}{sep}{instance}{sep}manifest
```

### Namespace Pattern

The namespace pattern determines how CsvPath Framework OpenLineage events are namespaced. It is a literal string with interpolated variables wrapped in braces. A namespace is required, but what it is is up to you. The available variables are:&#x20;

* prefix
* root\_path
* protocol\_root\_path
* root\_path\_separated
* root\_name

The prefix is usually a system or environment indicator. "csvpath", "edge", or "test" are all reasonable prefixes.&#x20;

The root that is the basis for root\_path, protocol\_root\_path, root\_path\_separated, and root\_name is the named-entity root set in your config.ini.  I.e. it is one of:

```ini
[inputs]
files = /my/local/files
csvpaths = s3://rules_bucket/my/s3/valiations

[results]
archive = sftp://mft.acme.com/my/published/data
```

Obviously, the URIs are up to you. These are your root paths. Data that is registered goes in the `files` root. Validations in the form of csvpath statements and ODCS schemas are loaded into the `[inputs] csvpaths` root. And the `[results] archive` is where clean data and metadata live.  &#x20;

The permutations of these roots are:

* `root_path` — the plain path
* `protocol_root_path` — the path, but updated if needed to have a `file://` or the technically correct azure storage protocol, rather than just `azure://`&#x20;
* `root_path_separated` — the root path, but with the `path_separator` value instead of `/` or `\` characters
* `root_name` — the last path segment of the root path. I.e. for `[inputs] files = data/2026/invoices` the `root_name` is `invoices`.&#x20;

### Verbs

In order to make a meaningful job name that indicates both what happened and to whom, we can add a verb. These verbs can be whatever makes sense to you. And you don't have to use them in your names, as we'll discuss below.

```ini
job_register_verb = register
job_load_verb = load
job_run_verb = run_group
job_run_instance_verb = run_instance
```

Generally we talk about data being registered so register is the default job\_register\_verb. Likewise we talk about schemas and validation rules being loaded so they can be applied. The default job\_load\_verb is simply load.

Run jobs kickoff a job for each of their component csvpath statements. (An XSD, ODCS, or JSON Schema has a csvpath statement, even if it is trivial). Since the main run is applying a named-paths group to some registered data, the default is run\_group.&#x20;

We call the component csvpath statements within a named-paths group instances. The job\_run\_instance\_verb uses run\_instance to make it clear the the context is a run, but the event is from a specific csvpath statement instance.

### Names

Names are created as literal strings with variable substitution tokens wrapped in braces. The same form as for namespaces.&#x20;

These names indicate jobs and datasets. For registration there is one verb name and two dataset outputs, one for the registered data and one for its metadata. Likewise with loading.&#x20;

A run has a verb, but it doesn't have its own output dataset, other than for the manifest data it writes. So for runs we have just two names.

Entities again have the three names:&#x20;

* Verb representing the job
* The dataset representing the manifest
* Datasets for every file created and every transfer performed &#x20;

```ini
job_register_entity = {verb}{sep}{entity}
job_register_output = {entity}
job_register_manifest = {entity}{sep}manifest

job_load_entity = {verb}{sep}{entity}
job_load_output = {entity}
job_load_manifest = {entity}{sep}manifest

job_run_entity = {verb}{sep}{entity}
job_run_manifest = {entity}{sep}manifest

job_run_instance_entity = {verb}{sep}{entity}{sep}{instance}
job_run_instance_output = {entity}{sep}{instance}{sep}{file}
job_run_instance_manifest = {entity}{sep}{instance}{sep}manifest
```

You can use the following tokens in your names:

* `verb` — the action the job does
* `entity` — the name of the named-entity (e.g. for a named-file called `orders`, the entity is `orders`)
* `sep` — the value of the `path_separator` key
* `instance` — the identity of a csvpath statement (set in its metadata or simply its index within its group)
* `file` — the name of a file generated by the run

As you can see, the default adds the literal `manifest` in the identifiers for the metadata output of a job. You can use any word you like, but the `manifest.json` is what you're talking about and its name has to be distinct.

### Screenshots of OpenLineage

{% hint style="info" %}
If you have an OpenLineage use case we haven't thought of or you run into problems in configuration, please let us know at [support@csvpath.org](mailto:support@csvpath.org). We're eager to learn about your requirements and help make it work for you.
{% endhint %}

#### Marquez

<figure><img src="../../../.gitbook/assets/Screenshot 2026-10-09 at 5.23.34 PM.png" alt=""><figcaption></figcaption></figure>

<figure><img src="../../../.gitbook/assets/Screenshot 2026-10-11 at 11.36.23 AM.png" alt=""><figcaption></figcaption></figure>

#### DataHub

<figure><img src="../../../.gitbook/assets/Screenshot 2026-10-01 at 7.22.01 PM.png" alt=""><figcaption></figcaption></figure>

#### DataDog

<figure><img src="../../../.gitbook/assets/Screenshot 2026-10-08 at 7.26.32 PM.png" alt=""><figcaption></figcaption></figure>

<figure><img src="../../../.gitbook/assets/Screenshot 2026-10-08 at 7.18.57 PM.png" alt=""><figcaption></figcaption></figure>

<figure><img src="../../../.gitbook/assets/Screenshot 2026-10-01 at 7.40.18 PM.png" alt=""><figcaption></figcaption></figure>
