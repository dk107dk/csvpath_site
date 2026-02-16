# Handling Variability

Named-files have to account for several things that are important to data operations:

| Reason for variability                                                      | Example                                                                                                                                                                                                                     |
| --------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Business process change over time                                           | May's orders are not the same as June's orders so they probably go in either a different file name or a different directory or both name and directory are different. Likewise, Q1 orders are not the same as March orders. |
| File name changes that humans make to track file contents or system changes | May's orders may be in 2025-05-30-orders.csv; whereas, June's orders could be in 2025-06-30.csv or even 2025-06-30-SAP.csv, if a new system was switched on.                                                                |
| Revisions to the content of files that are notionally the same              | The books may have closed on April 2025 orders too soon, resulting in the production of a second 2025-04-30.csv file with slightly different data.                                                                          |
| Sets of files that collectively make up a single unit of data               | For practicality, Q1 orders for EMEA may be too large for a single data file.                                                                                                                                               |
| Multiple downstream readers may need different cuts of the data             | Again, for practical reasons, we might want to split up the March orders for fifteen US regions so that compensation calculations and Sales decision analytics can each get just the information they need.                 |

And there may be other reasons or similar cases such as these.

CsvPath Framework starts from the premise that doing everything as simply as possible and in exactly the same way will be the most efficient and have the lowest risk. But it recognizes that the World isn't that simple. In reality there are good reasons to go beyond named-files simply referring the the most recently registered file and, instead, take account of all the variability we typically see.&#x20;

To deal with variability in our source named-files we need two things: 1.) templates that organize named-files layouts, and 2.) query-like references that allow us to pick out the files we want to validatem upgrade, and publish.
