defmodule LyricsCache do
  @moduledoc """
  A module to cache lyrics and fetch them from an API if not cached.
  """

  @cache_file "lyrics_cache.json"

  def start_link(_) do
    {:ok, load_cache()}
  end

  def get_lyrics(artist, song) do
    cache_key = "#{String.downcase(artist)}_#{String.downcase(song)}"

    case Map.get(load_cache(), cache_key) do
      nil ->
        IO.puts("Fetching from API...")
        lyrics = fetch_lyrics_from_api(artist, song)

        if lyrics do
          cache = load_cache()
          updated_cache = Map.put(cache, cache_key, lyrics)
          save_cache(updated_cache)
        end

        lyrics

      lyrics ->
        IO.puts("Fetching from cache...")
        lyrics
    end
  end

  defp fetch_lyrics_from_api(artist, song) do
    url = "https://api.lyrics.ovh/v1/#{artist}/#{song}"

    case Req.get(URI.encode(url)) do
      {:ok, %Req.Response{status: 200, body: body}} ->
        body
        # |> Jason.decode!()
        |> Map.get("lyrics", "")
        |> String.split("\n")
        |> Enum.drop(1)
        |> Enum.filter(&(String.trim(&1) != ""))

      _ ->
        IO.puts("Lyrics not found for the selected song." <> url)
        nil
    end
  end

  defp load_cache do
    if File.exists?(@cache_file) do
      @cache_file
      |> File.read!()
      |> Jason.decode!()
    else
      %{}
    end
  end

  defp save_cache(cache) do
    json_string = Jason.encode!(cache)
    File.write!(@cache_file, json_string)
  end
end
