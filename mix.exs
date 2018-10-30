defmodule SimpleSlug.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :simple_slug,
      version: @version,
      elixir: "~> 1.4",
      deps: deps(),

      # docs
      name: "SimpleSlug",
      source_url: "https://github.com/vforgione/simple_slug",
      docs: [
        main: "SimpleSlug"
      ],
      package: package()
    ]
  end

  def application, do: []

  defp deps, do: [
    {:ex_doc, "~> 0.19", only: :dev, runtime: false}
  ]

  defp package, do: [
    files: ["lib", "mix.exs", "COPYING", "LICENSE"],
    maintainers: ["Vince Forgione"],
    licenses: ["GPL-v3"],
    links: %{
      GitHub: "https://github.com/vforgione/simple_slug"
    }
  ]
end
