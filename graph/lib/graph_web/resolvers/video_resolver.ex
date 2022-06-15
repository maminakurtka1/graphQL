defmodule GraphWeb.Resolver do
  alias Graph.Tools.CmdClient

  def create_video(%{images: images}, _info) when is_list(images) do
    dir = generate_dir_name()
    File.mkdir_p(dir)

    process_images(images)
    |> write_images(dir)

    CmdClient.exec(
      "ffmpeg -framerate 1 -pattern_type glob -i #{dir}/*.jpg -c:v libx264 -r 30 -pix_fmt yuv420p #{dir}/out.mp4"
    )

    result_path = String.replace(dir, "priv/static", "")
    {:ok, %{video_path: "#{result_path}/out.mp4"}}
  end

  defp process_images(images) when is_list(images) do
    images
    |> Enum.map(fn image ->
      String.split(image, "base64,")
    end)
    |> Enum.map(fn [_ | [image]] ->
      image
    end)
  end

  defp write_images(images, dir) do
    images
    |> Enum.with_index(fn image, index ->
      "#{Path.join(dir, to_string(index))}.jpg"
      |> File.write!(Base.decode64!(image))
    end)
  end

  defp generate_dir_name do
    gen_name =
      Enum.to_list(1..10)
      |> Enum.map(fn _ -> Enum.random('0123456789abcdef') end)

    "priv/static/videos" |> Path.join(gen_name)
  end
end
