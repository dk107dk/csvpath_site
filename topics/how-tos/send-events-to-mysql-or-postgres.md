---
description: Some multi-user archives may benefit from capturing events to the database
---

# Postgres and MySQL

<figure><img src="../../.gitbook/assets/Screenshot 2025-04-03 at 5.02.52 PM.png" alt="the logos of mysql, postgres, and sqlite"><figcaption></figcaption></figure>

CsvPath Framework is great for both individual developer users and large groups of DataOps pros taking care of many data partnerships. The difference between these scenarios is important, however. You can read more about it here.

## Why go with SQL?

There are three obvious reasons to consider setting up a database for CsvPath Framework:&#x20;

* Querying SQL is much more productive for some purposes, compared to going through the `manifest.json` files. [Sqlite also solves for this locally.](send-run-events-to-sqlite.md)
* A SQL database is an immutable record of changes; whereas, `manifest.json` files can be overwritten or deleted if the archive and staging areas are not protected
* In some cases other applications can more easily use SQL to get CsvPath Framework data

## Filesystem overwrites and races

In general, CsvPath Framework assumes it has privileged access to protected file system space for its archive, the source file staging area, and the named-paths area. That is absolutely the right way to go in production. In dev environments, though, things can certainly be a bit looser.

If you are working with your peers in a shared archive or a shared source file staging or named-paths area you should consider using a SQL database to capture events. When you work on the same files you run the risk over overwrites. That is no different from any shared data system — for e.g. you can have the same problem in JIRA, Git, or Sharepoint.&#x20;

However, CsvPath's filesystem data writes are necessarily not all atomic. In certain cases, there is a race condition around file system writes. That is typically not a consideration for automated runs. When CsvPath is automated typically there is a single Python process working on a particular run, not two Python processes competing over one run. Moreover, most CsvPath Framework automations will have their own protected area namespaced by named-paths name or archive name or both.&#x20;

Still, in development environments and for some corner cases you might want your audit trail to have more immutability. For this the SQL databases have you covered. All metadata writes, whether to the `manifest.json` files in the file system, to a local Sqlite, or to a SQL database server, are handled by event listeners. You've probably seen the many optional listeners in your `config/config.ini`. When you write to the file system you overwrite any existing file in the location. But when your events go to SQL you are creating an even more immutable record that can disambiguate any cross-talk in the manifests due to a non-ideal setup of your automation jobs or a shared dev env without namespacing.&#x20;

## Setting up SQL databases

Setting up SQL events is not hard at all. Still, as you can tell, we would only suggest it if the benefit is worth running a server, managing the four tables, and distributing credentials. If you're just in need of better layout of your archive and/or named-paths, obviously that's the even easier and more correct thing to focus on. For most folks, that's all you need. And, if you're just in need of a way to query your results, [a local Sqlite may be a more lightweight solution](send-run-events-to-sqlite.md). As you can tell, we're all about a low-friction [DX](https://en.wikipedia.org/wiki/User_experience#Developer_experience).

Regardless, to configure for SQL what you need is:

* The listeners are enabled
* Your database URL is available in `config/config.ini`

### Configure the listeners

Open `config/config.ini` and look for the `[listeners]` section. It should have the SQL listeners already. But if your config file is not newly generated, it might not. Copy the keys below into your file, if needed.

<figure><img src="../../.gitbook/assets/Screenshot 2025-04-03 at 4.28.00 PM.png" alt="what your config file should look like. same as the text below."><figcaption></figcaption></figure>

```python
sql.file = from csvpath.managers.integrations.sql.sql_file_listener import SqlFileListener
sql.paths = from csvpath.managers.integrations.sql.sql_paths_listener import SqlPathsListener
sql.result = from csvpath.managers.integrations.sql.sql_result_listener import SqlResultListener
sql.results = from csvpath.managers.integrations.sql.sql_results_listener import SqlResultsListener
```

Then look for the `groups` key in `[listeners]` and add `sql` to it, separating with a comma, if needed.&#x20;

### Configure the database URI

Check for a `[sql]` section. If your `config.ini` isn't newly generated copy the `[sql]` section from below into your file.

<figure><img src="../../.gitbook/assets/Screenshot 2025-04-03 at 4.31.52 PM.png" alt="screenshot of a config file, same as the text below"><figcaption><p>You may already have this SQL section if you generated your config recently</p></figcaption></figure>

```ini
[sql]
dialect = mysql
connection_string = mysql://csvpath:password1@192.168.1.1/csvpath
```

The `dialect` key value must be one of:&#x20;

* `mysql`
* `postgres`
* `sqlite`

Under the hood we're using [SQLAlchemy](https://www.sqlalchemy.org/), so you can [look here for the connection string formats](https://docs.sqlalchemy.org/en/20/core/engines.html#database-urls).

As usual, you can use an ALL CAPS value to point to the environment var of that name. For e.g., `connection_string = CONNECTION_URI` would result in `connection_string` equaling the value of the `CONNECTION_URI` environment variable, if found.

That's all the configuration needed.

## The database structure

Your data is now ready to flow into the database. CsvPath Framework will create the database for you in the background. The database is `csvpath` and the tables are:&#x20;

* `instance_run`
* `named_file`
* `named_paths`
* `named_paths_group_run`

<figure><img src="../../.gitbook/assets/Screenshot 2025-04-03 at 4.40.25 PM.png" alt="screenshot of the mysql command line client" width="375"><figcaption></figcaption></figure>

You are capturing:&#x20;

* `NAMED_FILE`: The same information as in the `manifest.json` created when you add a named-file
* `NAMED_PATHS`: The same for named-paths
* `NAMED_PATHS_GROUP_RUN`: The run manifest for the named-paths group run found in its `run_dir`  (a.k.a. the run's home)
* `INSTANCE_RUN`: The run manifest for each individual csvpath in the named-paths group being run

The database is quite simple. It is nothing more than an immutable record (unless you mutate it outside of CsvPath) of the assets and runs your CsvPath Framework performs. That's all it needs to be.

<figure><img src="../../.gitbook/assets/Screenshot 2025-04-03 at 4.56.13 PM.png" alt="an ERD generated in Mysql Workbench showing the four tables."><figcaption></figcaption></figure>

And there you have it. All your events captured to your favorite database.

