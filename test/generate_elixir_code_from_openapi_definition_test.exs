defmodule GenerateElixirCodeFromOpenapiDefinitionTest do
  use ExUnit.Case
  doctest GenerateElixirCodeFromOpenapiDefinition

  test "generates a route string" do
    assert String.starts_with?(
             GenerateElixirCodeFromOpenapiDefinition.generate("test/fixtures/simple.yaml"),
             "defmodule"
           )
  end
end
