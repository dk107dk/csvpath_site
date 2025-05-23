---
description: A checklist for implementing SFTPPlus + CsvPath
---

# SFTPPlus Implementation Checklist

_For this checklist we are assuming the client-side and server-side are on the same machine. In a production situation the client-side would be wherever the CsvPath writers do their work and the server-side would be on a different, centrally-managed machine(s)._

## Steps To Implement SFTPPlus + CsvPath

* [ ] **Platforms and applications**
  * [ ] Install SFTPPlus
  * [ ] Install Python
  * [ ] Install Pipx and Poetry
* [ ] **SFTPPlus config**
  * [ ] Create the mailbox account&#x20;
    * [ ] Create the `mailbox` user and their storage directory
    * [ ] In the `mailbox` storage directory create a `handled` dir
  * [ ] Create the data partner's account and their storage directory
* [ ] **Create a server-side CsvPath workspace**
  * [ ] Pick a location and do: `poetry new <project-name>`
  * [ ] Add CsvPath to the project: `poetry add csvpath`
  * [ ] Start and quit the CLI to generate the `config/config.ini` file: `poetry run cli`
  * [ ] Add SFTPPlus integration fields to `config/config.ini` &#x20;
  * [ ] &#x20;Set the `[inputs] named_paths` location to a location that is accessible to the client side (On the local filesystem, S3, or a file share)
  * [ ] Add the SFTPPlus integration's four scripts from Github to the project's root directory
  * [ ] Check to make sure the two `.sh` or `.bat` scripts call your Poetry install correctly
* [ ] **Create a client-side CsvPath workspace**
  * [ ] Pick a location and do: `poetry new <project-name>`
  * [ ] Add CsvPath to the project: `poetry add csvpath`
  * [ ] Start and quit the CLI to generate the config file: `poetry run cli`
  * [ ] Add SFTPPlus integration fields to `config/config.ini`&#x20;
  * [ ] Set the `[inputs] named_paths` property to the location that the server-side is also configured to use
* [ ] **Load your first named-paths**
  * [ ] Add SFTPPlus directives to the csvpath's metadata comments
  * [ ] Run the CLI and load the csvpath into CsvPath Framework
  * [ ] See that the named-paths file shows up in the location configured in `[inputs] named_paths`&#x20;
  * [ ] Watch as a metadata file lands in the `mailbox` account, creates the named-files transfer, and is moved to the mailbox's `handled` directory
* [ ] **Drop your first data file**
  * [ ] SFTP your file to the data partner's account, putting it in the named-file name directory
  * [ ] See that the file is moved to the `handled` directory
  * [ ] Check that the file shows up in the directory or bucket configured in `[inputs] named_files`&#x20;
  * [ ] Check that the archive is created at the location configured in `[results] archive`&#x20;
  * [ ] See that the new file is processed, moved into `handled`, and the named-paths run's results show up in the archive

## What you have achieved

You're done. Congratulations! What you have achieved is:&#x20;

* Your csvpath writers can **easily configure more automated transfers** with minimal assistance
* The server operator **never needs to worry about new data drops**. They just create user accounts as needed and otherwise manage the SFTPPlus server.
* Your csvpath writers can **turn transfers on and off and make other changes without help**
* The data partner can **drop their files with confidence**
* You can improve the robustness of your DataOps with **strong identification, validation, and canonicalization capabilities**. The data you stage now has **traceability and durability**. And you now have the ability to **easily rewind and replay data processing steps.**
* You can **easily add pre-integrated observability and alerting** tools so you can keep track of data flows and react quickly to any anomalies &#x20;
