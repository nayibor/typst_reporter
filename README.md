# TypstReporter

This is a elixir application that enables you to write sql queries and uses [typst](https://typst.app/)  to create reports using the results of the queries.

You can write your own typst scripts and the title,rows and columns will be available to your scripts as inputs in the format below

```
#let rowData = json.decode(sys.inputs.rowData)
#let colData = json.decode(sys.inputs.colData)
#let title = json.decode(sys.inputs.title)

//write any custom typst script here for generating reports here
...

```

##Warning

It is highly recommended that you create a seperate user with resticted privileges for running reports and also create a repo for that user.

You then supply that repo as a environmental variable in your config file for the **typst_reporter** application.

This is to prevent abuse of the reporting interface for malicious purposes.

##Installation
  * Add the following dependancy to your `mix.exs`
  * Run `mix deps.get` to download dependancy
  * Run the task to generate the  router links and migration files needed for the reporting interface
  * Create a new repo for the report user or use a repo of your choice as a config for **typst_reporter** application 
  * Run `mix ecto.migrate` script needed for creating the table needed for the **typst_reporter** application.
