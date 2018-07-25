defmodule Genderize do
  use Application
  use GenServer

  @type gender :: :male | :female | :unknown

  @type probability :: float

  # Public Functions

  @doc false
  def child_spec(_) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []}
    }
  end

  @doc """
  Starts the Genderize process.
  """
  @spec start_link() :: {:ok, pid}
  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @doc """
  Gets the gender and probability for a name.

  ## Example
      Genderize.find("mary")
      # => {:male, 1.0}
      Genderize.find("john")
      # => {:male, 1.0}
      Genderize.find("asdf")
      # => {:unknown, nil}
  """
  @spec find(name :: binary) :: {gender, probability}
  def find(name) do
    case :ets.lookup(:genderize, String.downcase(name)) do
      [{_, {gender, probability}}] -> {gender, probability}
      [] -> {:unknown, nil}
    end
  end

  # Application Callbacks

  @doc false
  @impl true
  def start(_type, _args) do
    children = [
      Genderize
    ]

    opts = [strategy: :one_for_one, name: Genderize.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # GenServer Callbacks

  @doc false
  @impl true
  def init(_) do
    start_cache()
    load_cache()

    {:ok, :ok, :hibernate}
  end

  # Private Functions

  defp start_cache do
    case :ets.info(:genderize) do
      :undefined ->
        :ets.new(:genderize, [
          :set,
          :public,
          :named_table,
          {:write_concurrency, true},
          {:read_concurrency, true}
        ])

        :ets.info(:genderize)

      info ->
        info
    end
  end

  defp load_cache do
    with {:ok, source} <- fetch_source() do
      source
      |> parse_csv()
      |> Task.async_stream(&cache_insert(&1))
      |> Enum.to_list()

      :ok
    end
  end

  defp fetch_source do
    :genderize
    |> :code.priv_dir()
    |> Kernel.++('/source.zip')
    |> :zip.extract([:memory])
    |> case do
      {:ok, [{_, source}]} -> {:ok, source}
      error -> error
    end
  end

  defp parse_csv(source) do
    source
    |> String.split("\n")
    |> Enum.map(&String.split(&1, ","))
  end

  defp cache_insert([name, gender, probability]) do
    {probability, _} = Float.parse(probability)
    :ets.insert(:genderize, {name, {String.to_atom(gender), probability}})
  end

  defp cache_insert(_) do
    false
  end
end
