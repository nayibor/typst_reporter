defmodule TypstReporterWeb.PageController do
  use TypstReporterWeb, :controller
  alias TypstReporter.TypstReport
  
  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def process_report(conn,%{"id" => id }) do
    report = TypstReport.get_report!(id)
    result_query = TypstReport.run_report(report.db_query,[])
    {_,result_query} = result_query
    columns = result_query.columns
    rows = result_query.rows
    {:ok,title} = Jason.encode(report.title)
    {:ok,columns_data} = Jason.encode(columns)
    {:ok,rows_data} = Jason.encode(rows)
    filename = "#{report.title} Report"
    command = case report.use_default_typst do
      true ->
	path_typst = Path.join([:code.priv_dir(:typst_reporter),"/typst/typst"] )    
	path_api = Path.join([:code.priv_dir(:typst_reporter),"/typst/main.typ"] )
	path_template = "report.typ"
	command = "#{path_typst} compile  --input 'title=#{title}' --input 'rowData=#{rows_data}' --input 'colData=#{columns_data}' --input 'templatePath=#{path_template}' -f pdf #{path_api} -"
      false ->
	typst_string = report.typst_string
	path_typst = Path.join([:code.priv_dir(:typst_reporter),"/typst/typst"] )    
	command = "echo '#{typst_string}' | #{path_typst} compile  --input 'title=#{title}' --input 'rowData=#{rows_data}' --input 'colData=#{columns_data}' -f pdf - -"
    end
    {result,code_result} = System.cmd("sh",["-c",command])
    case code_result do
      0 -> send_download(conn,{:binary,result},content_type: "application/pdf",disposition: :inline,filename: filename )
      _ -> text(conn,"error generating pdf")
    end

  end
end
