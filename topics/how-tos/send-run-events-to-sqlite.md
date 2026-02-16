---
description: Capturing run events to Sqlite can make searching for answers faster
---

# Sqlite

<figure><img src="../../.gitbook/assets/sqlite_logo.jpeg" alt=""><figcaption></figcaption></figure>

You can easily send your runs metadata to Sqlite as well as to `manifest.json` files. Why might you want to do that? Sqlite gives you the ability to quickly search for runs that match certain characteristics. It contains most of the data in the results and result events so you can more easily query at multiple levels across runs.

Turning on the Sqlite backend is simple. It is pre-configured in your generated `config/config.ini`, when you create a new project. To add Sqlite to an existing project, pickup the latest version of CsvPath Framework from Pypi and add these to the `[listeners]` section of your `config.ini`:

```ini
[listeners]
sqlite.result = from csvpath.managers.integrations.sqlite.sqlite_result_listener import SqliteResultListener
sqlite.results = from csvpath.managers.integrations.sqlite.sqlite_results_listener import SqliteResultsListener
```

Also in `[listeners]`, you need to add the `sqlite` group to the `groups` key. If for some reason you want to, you can run the `SqliteResultsListener` without the `SqliteResultListener`, but the reverse is not true. I can't think of a reason to just one of the listeners, though.

Finally, you need a \[sqlite] section with a single key pointing to the file that will contain the database. This section and key will also be generated in any new `config.ini` created by the Framework. Or, you can add it like this, using any location you like:&#x20;

```ini
[sqlite]
db = archive/csvpath.db
```

That's all there is to it. Your events will now be captured to two tables in the database:&#x20;

* `named_paths_group_run`
* `instance_run`&#x20;

Recall that we use the terms `instance`, `identity`, and `csvpath` to refer to csvpaths that are managed by a `CsvPaths` object. The term `instance` stems from the object or instance of the `CsvPath` class. Identity refers to the optional but highly recommended `ID` or `name` metadata field you can add to your csvpath's external comments for better identification in error messages and logging. (E.g. to name a csvpath `my csvpath!` do something like: `~ id: my csvpath! ~ $[*][yes()]`)

As you would guess, `named_paths_group_run` is the main table describing a run. It is created from the `results` event by the `SqliteResultsListener`. `instance_run` is the description of a csvpath's results within the name-paths group. `instance_run` is populated from the `result` event handled by `SqliteResultListener`.

<figure><img src="../../.gitbook/assets/Screenshot 2025-02-18 at 4.00.29 PM.png" alt=""><figcaption></figcaption></figure>

Just for reference, the schema for the tables is here. You don't have to do anything with it, though. The tables are set up automatically when you enable the integration or anytime you delete the database.

```sql
       CREATE TABLE IF NOT EXISTS named_paths_group_run (
                uuid varchar(40) PRIMARY KEY not null,
                at datetime not null,
                archive_name varchar(100),
                time_completed datetime,
                all_completed varchar(1) default 'N',
                all_valid varchar(1) default 'N',
                all_expected_files varchar(1) default 'N',
                error_count int,
                status varchar(20),
                by_line_run varchar(1) default 'Y',
                run_home varchar(250),
                named_results_name varchar(45),
                named_paths_uuid varchar(40) not null,
                named_paths_name varchar(45) not null,
                named_paths_home varchar(250) not null,
                named_file_uuid varchar(40) not null,
                named_file_name varchar(45) not null,
                named_file_home varchar(500) not null,
                named_file_path varchar(500) not null,
                named_file_size int default -1,
                named_file_last_change,
                named_file_fingerprint varchar(70),
                hostname varchar(45),
                username varchar(45),
                ip_address varchar(40),
                manifest_path varchar(250)
        );

        CREATE TABLE IF NOT EXISTS instance_run(
                uuid varchar(40) PRIMARY KEY not null,
                at datetime not null,
                group_run_uuid varchar(40) not null,
                instance_identity varchar(100),
                instance_index int default -1,
                instance_home varchar(250) not null,
                source_mode_preceding varchar(1) default 'N',
                preceding_instance_identity varchar(100),
                actual_data_file varchar(500),
                number_of_files_expected int default -1,
                number_of_files_generated int default -1,
                files_expected varchar(1) default 'Y',
                valid varchar(1) default 'N',
                completed varchar(1) default 'N',
                lines_scanned int default 0,
                lines_total int default 0,
                lines_matched int default 0,
                error_count int default -1,
                manifest_path varchar(250) not null,
                FOREIGN KEY(group_run_uuid) REFERENCES named_paths_group_run(uuid)
        );
```

Expanding the model to cover named-paths csvpath group loads and staging named-files is on the roadmap.&#x20;
