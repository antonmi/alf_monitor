ExUnit.start()

unless function_exported?(Tictactoe.DataCase, :__info__, 1) do
  root_path = Path.expand("../../../..", __ENV__.file)
  Code.eval_file("apps/tictactoe/test/test_helper.exs", root_path)
end
