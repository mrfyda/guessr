defmodule ConfigurationTest do
  use ExUnit.Case
  doctest Configuration

  test "has songs defined" do
    assert length(Configuration.songs_db()) > 0
  end
end
