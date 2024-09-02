# Validation Strategies

Rules-based validation is powerful. Its ability to make statements about data structure and data content and data-over-time goes well beyond schema formats like DDL or XSD. It does, however, bring its own challenges. One of which is how do you write rules in a way that is clear, consistent, and semantically informative. &#x20;

CsvPath validations can take different strategies. They can:&#x20;

* Focus on what good looks like, overall for the whole file and any file
* Address specific things that shouldn't happen
* Be broken down into steps that have no or little relationship to one another
* Collect the positive cases—what lines fit—or the negative cases or collect nothing and just indicate problems out of band and/or as a verdict at the end of a run&#x20;

These are all good choices. In order to have coherent validations that are easy to act on, it is good to be intentional up front about the strategy or strategies you want to take. Here are some notes about each.

### Focus on the good

Our first choice is the top strategy: focus on what constitutes a valid file. That approach fits very well with CsvPath. CsvPath is by default an AND system. (We use upper case because it is commonly written that way to distinguish ∧, the logical conjunctive from "and", the conjunction). That means all your match components are ANDed together to test if a line matches. If you say that a beautiful day has a blue sky, the sun is out, and the birds are singing, CsvPath can help validate that it is true.

While focusing on the positive aspects of your data may also be easier than thinking about the universe of exceptional cases, the bigger concern is that exceptions are ORed. Declaring that it is not a beautiful day if the sun is not out, or the birds are not singing, or the sky is not blue is a less of a fit with CsvPath. You can easily create those rules. But you will sometimes have to wrap functions and equalities in not()s and all your rules would need to be wrapped in one or(). Nothing says you can't do it. And it's not especially hard. But it isn't as good a fit.

### Separate AND equal&#x20;

Another approach to rule writing is to worry less about AND vs. OR and instead create some separation between your match components so that the don't impact each other.
