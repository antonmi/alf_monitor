defimpl Jason.Encoder, for: Any do
  def encode(value, opts) when is_struct(value) do
    map = Map.from_struct(value)
    Jason.Encode.map(map, opts)
  end

  def encode(value, opts) do
    Jason.Encode.string(inspect(value), opts)
  end
end
