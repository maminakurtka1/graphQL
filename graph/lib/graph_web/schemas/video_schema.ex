defmodule Graph.Schema do
  use Absinthe.Schema

  @desc "Image"
  object :video do
    field(:video_path, :string)
  end

  # Example data
  # @menu_items %{
  #   encode_string: "sosi hui"
  # }

  query do
  end

  mutation do
    field :create_video, :video do
      arg(:images, list_of(:string))

      resolve(&GraphWeb.Resolver.create_video/2)
    end
  end
end
