# TypstReporter

This is a elixir application that enables you to write sql queries and uses [typst](https://typst.app/)  to create simple reports using the results of the queries.

The reports are automatically generated due to elixir returning the rows and columns needed for rending the rows and the columns for the report.

The default typst report generates the report but you can write custom typst scripts when creating the report and specify to use the custom typst code not the default.

This will result in the custom typst code being used to generate the report.

the rows and columns data will be available to your typst script using the statements below

```
#let rowData = json.decode(sys.inputs.rowData)
#let colData = json.decode(sys.inputs.colData)
#let title = json.decode(sys.inputs.title)
...
//write any custom typst script here for generating reports here
```

##Warning

It is highly recommended that you create a seperate user for running reports and also create a repo for that user.

You then supply that repo as a environmental variable in your config file for the **typst_reporter** application.

The user must also have restrictions on the kind of queries it can run (usually in this case  **select** statements and  for only specific tables relevant for reports).

This is to  prevent abuse of the reporting interface for malicious purposes.

##Installation
  * Add the following dependancy to your `mix.exs`
  * Run `mix deps.get` to download dependancy
  * Run the task to generate the  router links and migration files needed for the reporting interface
  * Create a new repo for the report user or use a repo of your choice as a config for **typst_reporter** application 
  * Run `mix ecto.migrate` script needed for creating the table needed for the **typst_reporter** application.
