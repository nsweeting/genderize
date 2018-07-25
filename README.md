# Genderize

An easy way to associate a given name with a gender.

## Installation

The package can be installed by adding `genderize` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:genderize, "~> 0.1.0"}
  ]
end
```

## Usage

Using `genderize` is easy:

```elixir
Genderize.find("mary")
# => {:male, 1.0}
Genderize.find("john")
# => {:male, 1.0}
Genderize.find("asdf")
# => {:unknown, nil}
```

## Documentation

See [HexDocs](https://hexdocs.pm/genderize) for additional documentation.
