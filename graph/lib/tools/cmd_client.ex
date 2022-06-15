defmodule Graph.Tools.CmdClient do
  def exec(command) do
    [cmd | params] = String.split(command, " ")

    case System.cmd(cmd, params, stderr_to_stdout: true) do
      {response, 0} ->
        {:ok, response}

      {response, _} ->
        "Failed CMD: #{command}"

        {:error, response}
    end
  end
end
