---
description: SFTP is a bedrock backend provider that also enables seamless operations
---

# SFTP

CsvPath Framework uses SFTP in three ways:&#x20;

* First and foremost, as a backend provider
* As a source for file registrations into named-files
* As a target for transfers of files from run results

#### A Backend Provider

[We cover storage backends elsewhere](../storage-backends/). Basically, you can setup one SFTP storage backend per project. Using that backend configuration, you can locate your named-file staging, named-paths groups validation, and/or results archive in that SFTP server. You can also register data files from any location in that server that your credentials can access. Similarly, you can transfer result files from the archive to any location in that server your credentials have access to.

#### A Source Of Files To Register

Files can be registered into a named-file from any number of SFTP servers, as long as you configure those servers in your named-file's definition.json. When you attempt to register a file at, say, `sftp://my-sftp-server.acme.com:2022/the/file.jsonl`, but you don't have `my-sftp-server.acme.com` on port `2022` as a backend, your `FileManager` will look in the definition of the named-file you want to register `/the/file.jsonl` into to see if there is a match on `my-sftp-server.acme.com` and `2022`. If there is, the registration happens.

#### A Target For Result Files Transfers

In a similar way to how named-files can have SFTP server configurations, named-paths also can have them. In the case of a named-paths, [SFTP use is during transfers](../transfers/). As you probably know, any result file can be transferred to a destination in any of the project's backends. SFTP is a special case. With SFTP you can setup additional server-port configs in addition to or alongside the backends. There are two methods of doing post-run results transfers: transfers defined on the csvpath statement (`transfer-mode:`) and transfers defined in the named-paths group `definition.json`. Both can use the additional SFTP servers, if any are configured.



