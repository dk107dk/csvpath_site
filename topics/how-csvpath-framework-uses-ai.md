---
description: A breakdown of how AI is used, so you can see clearly what data travels where
hidden: true
---

# How CsvPath Framework Uses AI

Several parts of CsvPath Framework, FlightPath Data, and FlightPath Server are powered by AI. This makes it important to understand how your data and other assets come into contact with external APIs.&#x20;

At a high level, the touchpoints are:

1. Creating test data from CVL (CsvPath Validation Language) — a FlightPath feature\*
2. Generating CVL from English business language — a FlightPath feature
3. Explaining CVL in plain English — a FlightPath feature
4. Answering questions about how to use CVL — a FlightPath feature&#x20;
5. Using Jev to create custom validation rules — a Framework feature
6. Within AWS Macie-compatible sensitive data discovery — a Framework feature
7. Using Agents and CRL (CsvPath Reference Language) to autonomously report on activity, health, and concerns in real-time during Framework operations. — a FlightPath feature
8. Using Agents and CRL to autonomously investigate, report on, and troubleshoot problems discovered downstream that may have originated in your edge data estate, with audit-friendly explainable results  — a FlightPath feature

{% hint style="info" %}
_\* Note that FlightPath is, in the main, open-source, like the Framework. However, a few embedded components are distributed free, but are not themselves open-source._
{% endhint %}

These AI touchpoints are intrinsic to the maximum-value operations of the Framework and/or FlightPath. However, they are all:&#x20;

* Optional - the tools remains powerful without them
* Able to be run using locally deployed agents (excepting only rules based on Jev)

This first point is important:&#x20;

* Touchpoints 1 through 4 are simply optional productivity tools that have significant ability to make your work better and much faster. But if you are already comfortable with CVL or only working with ODCS you may not need them.&#x20;
* Item 5, Jev, is a user directed force multiplier in that it gives you the ability to reach strong determinations of validity under unpredictable conditions.&#x20;
* Touchpoint 6 gives you a powerful equalizer to AWS's proprietary use of ML in Macie, which is obviously not available outside AWS.&#x20;
* And 7 and 8 are powerful, but optional, capabilities that can improve your compliance posture and day-to-day visibility. &#x20;

If you wish to use these AI powered features, your data may travel to public AI API backends. But in most of the touchpoints, you can work against an AI API running behind your firewall. Jev is the only AI tool that you can not run locally.&#x20;

While most use of AI is in FlightPath Data and FlightPath Server, CsvPath Framework holds all the AI API key variables or pointers to environment variables. This is because AI use is configured at the project level.&#x20;

Model name, key, and API endpoint can be pointed at a local Ollama or other model runner. Running local LLM models, and switching Jev off, keeps your data behind the firewall. Alternatively, for CVL tasks, such as creating or explaining complex CVL validations, using representative demo data may provide the context you need without exposing any real data to a public API.&#x20;

{% hint style="warning" %}
Practically speaking, running a local model that is able to generate and interpret CVL and CRL requires substantial hardware. Both languages have a non-trivial number of functions and optional settings that more than balance their simple syntax. The frontier models can easily ingest the context that teaches the languages and use the tools for generating and interpreting the languages, planning investigations, and exploring data. Local models are more challenged, particularly those that are laptop friendly. Our testing with Ollama suggests you should run a model that requires a much more capable machine than even a large capacity, high performance laptop or typical desktop.
{% endhint %}

FlightPath's use of AI is turn-limited, tracks spend, and its observability metadata is storage-limited. CsvPath Framework's use of Jev is not turn-limited or spend-limited and may not capture usage information (check your version's release notes to see what metadata capture is supported). Jev is far less expensive per token than an LLM, so the risks are mainly in the data that is shared with the API. Since that data use is determined at the CVL level, it is is fully under the user's control.&#x20;
