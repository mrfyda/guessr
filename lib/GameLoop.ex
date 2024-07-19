defmodule GameLoop do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @impl true
  def init(state) do
    play_game()
    {:ok, state}
  end

  def get_random_song do
    Configuration.songs_db()
    |> Enum.random()
  end

  def play_game do
    :rand.seed(:exsplus, :os.timestamp())
    song = get_random_song()
    lyrics = LyricsCache.get_lyrics(song["artist"], song["title"])

    if lyrics == nil || lyrics == [] do
      IO.puts("Lyrics not found for the selected song. Try again.")
      IO.inspect(song)
      :ok
    else
      IO.puts("Guess the song based on the lyrics!\n")
      IO.puts("Lyrics:\n")

      max_attempts = min(5, length(lyrics))
      start_index_range = length(lyrics) - max_attempts
      start_index = :rand.uniform(start_index_range + 1) - 1

      play_round(song, lyrics, max_attempts, start_index, 0)
    end
  end

  defp play_round(song, lyrics, max_attempts, start_index, attempts) do
    lyrics
    |> Enum.slice(start_index, attempts + 1)
    |> Enum.each(fn line ->
      if compare_strings(line, song["title"]) > 0.6 do
        IO.puts("****************")
      else
        IO.puts(line)
      end
    end)

    guess = IO.gets("\nYour guess: ") |> String.trim()

    if compare_strings(guess, song["title"]) > 0.8 do
      IO.puts("\n#{song["artist"]} - #{song["title"]}")
      :ok
    else
      if attempts + 1 < max_attempts do
        play_round(song, lyrics, max_attempts, start_index, attempts + 1)
      else
        IO.puts("\nYou've used all attempts. The song was: #{song["title"]}")
        :ok
      end
    end
  end

  defp compare_strings(string1, string2) do
    Simetric.Jaro.Winkler.compare(String.downcase(string1), String.downcase(string2))
  end
end
