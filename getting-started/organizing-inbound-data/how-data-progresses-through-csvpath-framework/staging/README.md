# Staging

## How does CsvPath Framework work with your data layout?

In most cases there is an existing process for collecting data files from MFT. How can CsvPath fit in?&#x20;

CsvPath Framework stages your data in a source files area and publishes valid and/or upgraded data to a long-term archive. If you are in a greenfield situation, you may be able to keep things simple and just use names to identify files or types of files. Flat structures are easy, but it might not fit perfectly with what you're trying to do.

To make a nested source file repository in CsvPath you use a file location **template**. A template is a way to use the original landing location to create a structure of CsvPath source-file folders.  It works like this.

This template:&#x20;

```url
orders/:1/:3/:filename
```

Given a file that arrived at this location:

```url
/customers/acme/orders/2025/March/29-mar-2025-acme-orders.csv
```

Would be stored at:

```url
named_files/orders/acme/2025/29-mar-2025-acme-orders.csv
```

Where `named_files` is a user-configurable name for your source file staging area. The template uses the `:1` and `:3` tokens to add the second and fourth element of the source path to the destination path. (Like many things in technology these tokens are 0-based). The `:filename` token is exactly what it sounds like: the name of the file being stored. And the word `orders` is just static text used with every file. Templates allow you to match your existing file layout exactly, or create a new one that works better for a particular purpose.

Templates are especially powerful for their ability to let you import whole directory trees while reorganizing them. And having the directory tree you want make it easy to distribute source data and reference source data in CsvPath Validation Language for validation and upgrading.&#x20;

As always, you can have named-files with different file names (e.g. `march-orders.csv`, `april-orders.csv`, etc.) and, using templates, named-files that also have different parent directories. With this flexibility CsvPath Framework source file storage is close to a drop-in replacement for your current setup from the point of view of your existing tools and scripts.

## How about on the Trusted Publisher side?

This is skipping ahead, but let's look at the internal publishing side. How do downstream data consumers see it?

CsvPath Framework is the trusted publisher to your internal applications, data lake, analytics, etc. It makes data consistent and trustable across all sources. It also has to publish to its archive in a way that enables easy ingestion by those applications, the data lake, et. al.  CsvPath uses named-path templates to structure the archive, in a similar way to how we use templates to organize the source file staging area.

For example, this template:

```url
:1/orders/:3/:4/:run_dir/final
```

Combined with the source file (see above) original path and a named-paths group called `partner_sales`, we would see our output files in the archive at this location:

```url
archive/partner_sales/2025/orders/March/2025-3-27_14-35-03/final 
```

Where `archive` is a user-configurable name for the long-term immutable archive we are publishing data files to. The named-paths group `partner_sales` represents a set of csvpath statements that validate and upgrade our data files. The name `orders` is again a static directory name. The `:run_dir` token is the name of CsvPath's time-stamped output of our run. The `final` directory is another static directory name. Within the directory identified by this path you would see your `data.csv`, `errors.json`, `printouts.txt`, and the other run output files CsvPath generates.

This flexibility in the publishing layout helps downstream users find data quickly and easily. Your archive template is stored with your named-paths group. Each named-paths group can have its own template, allowing it to organize the layout of its area within the archive in the way most suited to its use case.&#x20;

## Flexibility — with consistency!

As you can see, CsvPath is both flexible and opinionated. The more you keep preboarding simple, the easier it is to run an efficient data onboarding process that is effective over the long term. However, most companies have an existing process they want to improve. They want to eliminate garbage-in-garbage-out without throwing the baby out with the bath water. CsvPath Framework gives you the flexibility to make those dramatic improvements with the minimum disruption to the way things work today.

Give it a shot. [Reach out if you have questions](../../../a-helping-hand.md). We can help!
