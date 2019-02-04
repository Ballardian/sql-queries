require 'sqlite3'
require 'pry-byebug'

def detailed_tracks(db)
  # TODO: return the list of tracks with their album and artist.
  rows = db.execute(
    "SELECT tracks.name, albums.title, artists.name
    FROM tracks
    JOIN albums ON albums.id = tracks.album_id
    JOIN artists ON artists.id = albums.artist_id"
  )
  # binding.pry
  # 'lol'
end

def stats_on(db, genre_name)
  # TODO: For the given category of music, return the number of tracks and the average song length (as a stats hash)
  db.results_as_hash = true

  query = <<-SQL
    SELECT
      ROUND(AVG(tracks.milliseconds) / 60000, 2) AS avg_length,
      genres.name AS category,
      COUNT(tracks.name) AS number_of_songs
    FROM tracks
    JOIN genres ON genres.id = tracks.genre_id
    WHERE genres.name = '#{genre_name}'
  SQL
  rows = db.execute(query).first
  # binding.pry
  genre_hash = {
    avg_length: rows["avg_length"],
    category: rows["category"],
    number_of_songs: rows["number_of_songs"]
  }
end

def top_five_artists(db, genre_name)
  # TODO: return list of top 5 artists with the most songs for a given genre.
  rows = db.execute(
    "SELECT artists.name, COUNT(*)
    FROM tracks
    JOIN albums ON albums.id = tracks.album_id
    JOIN genres ON genres.id = tracks.genre_id
    JOIN artists ON artists.id = albums.artist_id
    WHERE genres.name = '#{genre_name}'
    GROUP BY artists.name
    ORDER BY COUNT(*) DESC
    LIMIT 5"
  )

  # SELECT artists.name, COUNT (*) FROM tracks
  #   JOIN artists ON artists.id = albums.artist_id
  #   JOIN genres ON genres.id = tracks.genre_id
  #   JOIN albums ON albums.id = tracks.album_id
  #   WHERE genres.name =  '#{genre_name}'
  #   GROUP BY artists.name
  #   ORDER BY COUNT(*) DESC
  #   LIMIT 5")

  p rows
end


# db = SQLite3::Database.new("lib/db/jukebox.sqlite")
# p detailed_tracks(db)
