defmodule Tictactoe.Move do
  defstruct user_uuid: "",
            position: 0

  @type t :: %__MODULE__{
          user_uuid: String.t(),
          position: 0
        }
end
