defimpl Jason.Encoder, for: Any do
  def encode(value, opts) do
    Jason.Encode.string(inspect(value), opts)
  end
end
