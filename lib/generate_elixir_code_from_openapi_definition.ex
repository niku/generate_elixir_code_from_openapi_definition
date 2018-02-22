defmodule GenerateElixirCodeFromOpenapiDefinition do
  @moduledoc """
  Documentation for GenerateElixirCodeFromOpenapiDefinition.
  """

  def generate(path, options \\ []) do
    module_name = Keyword.get(options, :module_name, "MyRouter")
    {:ok, schema} = parse(path)

    EEx.eval_string(
      """
      defmodule <%= module_name %> do
        use Plug.Router

        plug :match
        plug :dispatch
      <%= for fragment <- fragments, do: fragment %>
        match _ do
          send_resp(conn, 404, "oops")
        end
      end
      """,
      module_name: module_name,
      fragments: fragments(schema.paths)
    )
  end

  def parse(filepath) do
    Swagger.parse_file(filepath)
  end

  def fragments(paths) do
    for {path, endpoint} <- paths,
        {verb, operation} <- endpoint.operations,
        {status_code, response} <- operation.responses do
      EEx.eval_string(
        """

          <%= verb %> "<%= path %>" do
            send_resp(conn, <%= status_code %>, "<%= Map.get(response, "example", "") %>")
          end
        """,
        path: path,
        entdpoint: endpoint,
        verb: verb,
        operation: operation,
        status_code: status_code,
        response: response
      )
    end
  end
end
