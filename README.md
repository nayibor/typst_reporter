# TypstReporter

This is a elixir application that enables you to write sql queries and uses [typst](https://typst.app/)  to create reports using the results of the queries.

You can write your own custom typst scripts for each report and the title,rows and columns will be available to your scripts as inputs in the format below

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
* Add the following dependancy  to your `mix.exs`
```
  {:typst_reporter, git: "https://github.com/nayibor/typst_reporter.git", tag: "0.1"}
```
  * Edit your `config.exs` and add your repo which will be used for reporting.**note above warning**.
```
  config :typst_reporter, repo: MyApp.Repo
```
* Add the following links to your `router.ex` file.
```
  scope "/", TypstReporterWeb  do
    get "/reports/process_reports/:id/", PageController, :process_report
    live "/reports", ReportLive.Index, :index
    live "/reports/new", ReportLive.Index, :new
    live "/reports/:id/edit", ReportLive.Index, :edit
    live "/reports/:id", ReportLive.Show, :show
    live "/reports/:id/show/edit", ReportLive.Show, :edit
    live "/reports/:id/preview", ReportLive.Index, :preview
  end
```
* Create a new migration `mix ecto.gen.migration add_typst_report` and add the following to the **change** function.
```
    create table(:typst_reports) do
      add :title, :string
      add :db_query, :text
      add :typst_string, :text
      add :use_default_typst, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end
```
* Run `mix ecto.migrate` script needed for creating the table needed for the **typst_reporter** application.
