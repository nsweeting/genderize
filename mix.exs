defmodule Genderize.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :genderize,
      version: @version,
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      docs: docs(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Genderize, []}
    ]
  end

  defp description do
    """
    An easy way to associate a given name with a gender
    """
  end

  defp package do
    [
      files: ["lib", "priv", "mix.exs", "README*"],
      maintainers: ["Nicholas Sweeting"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/nsweeting/genderize"}
    ]
  end

  defp docs do
    [
      extras: ["README.md"],
      main: "readme",
      source_url: "https://github.com/nsweeting/genderize"
    ]
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:benchfella, "~> 0.3.0", only: :dev}
    ]
  end
end
