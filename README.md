# GenerateElixirCodeFromOpenapiDefinition

Generate an elixir code from OpenAPI definition.

## Usage

```
$ cat test/fixtures/simple.yaml
swagger: "2.0"
info:
  version: "0.0.1"
  title: "Minimal API Sepcification"
paths:
  /greetings/hello:
    get:
      operationId: "hello"
      parameters: []
      responses:
        200:
          description: "succeeded"
          schema:
            type: "string"
            example: "hello"
    post:
      operationId: "hello with name"
      parameters: []
      responses:
        200:
          description: "succeeded"
          schema:
            type: "string"
            example: "hello niku"

$ mix run -e 'IO.puts GenerateElixirCodeFromOpenapiDefinition.generate("test/fixtures/simple.yaml")'
defmodule MyRouter do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/greetings/hello" do
    send_resp(conn, 200, "hello")
  end

  post "/greetings/hello" do
    send_resp(conn, 200, "hello niku")
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end
```
