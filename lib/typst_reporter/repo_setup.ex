defmodule TypstReporter.RepoSetup do
  defmacro __using__(_options)  do
    repo = unquote(Application.compile_env(:typst_reporter,:repo))
    quote do
       alias unquote(repo)
    end
  end
end
