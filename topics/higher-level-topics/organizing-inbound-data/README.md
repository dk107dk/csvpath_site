---
description: >-
  Organizing your preboarding data layout upfront makes the onboarding process
  efficient
---

# Organizing Inbound Data

## Every data onboarding process starts with a data preboarding stage

Preboarding is:&#x20;

* Data collection
* Dataset identification (a.k.a. file registration)
* Validation
* Upgrading
* Staging and archiving

After data is preboarded it is considered known and trustworthy and ready for ETL/ELT, workflow processes, use in applications, and the data lake.&#x20;

All onboarding processes include these data preboarding steps. The only question is how effective, efficient, and low-risk their implementation is. Often companies under-invest in the preboarding stage, resulting in manual validation and handling, more support issues, and rework. Shortcuts in preboarding have substantial long-term costs to the business.

<figure><img src="../../../.gitbook/assets/Screenshot 2025-03-27 at 11.26.05 AM.png" alt="Preboarding is the critical first step of the data onboarding process"><figcaption></figcaption></figure>

Underinvestment in preboarding exposes your company to&#x20;

* Manual handling costs
* Support time
* Rework by developers
* Refunds to annoyed customers

## So How Does Preboarding Work?

Files arrive through a Managed File Transfer process. MFT is a big topic. It includes:&#x20;

* SFTP / FTPS
* MFT servers providing a range of protocols and limited workflow support
* AS2 / AS4 file transfer, often used with EDI-related files
* Cloud buckets attached to cloud functions or other compute&#x20;
* etc.

In a few cases we see files dropped into a common area, differentiated only by file name or content. But that is rare. Files are typically stored in one of a few ways:

* By time of arrival
* By data partner
* By target application
* By jurisdiction
* By transaction or business process

<figure><img src="../../../.gitbook/assets/Screenshot 2025-03-27 at 11.48.01 AM.png" alt="Inbound data layout is important. There are four broad approaches." width="375"><figcaption><p>All of these approaches make sense in the right context</p></figcaption></figure>

These organizing concepts will be layered on on the other. For example, an orders business process alignment may include date and sales region in a hierarchy like this:

<figure><img src="../../../.gitbook/assets/Screenshot 2025-03-27 at 11.57.09 AM.png" alt="An example of one way to lay out inbound data files" width="375"><figcaption></figcaption></figure>

These are file directories in a file system holding CSV files. Clearly, this data layout is going to make it easy to find all orders in 2025 but much harder to see all the files holding the different sales person orders. Another layout might provide easy access in a different way.

## You have options!

How you arrange your data matters! Of course, at different times you may need different layouts. Since your data will eventually land in a database or warehouse or application, presumably your needs will ultimately be met. However, you have to consider how you store your data in preboarding in order to make onboarding and long-term reference to the source data efficient.



