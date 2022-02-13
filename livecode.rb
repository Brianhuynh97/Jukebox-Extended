require 'sqlite3'

db = SQLite3::Database.new("chinook.sqlite")

def customers(db)
  results = db.execute"
    SELECT first_name, last_name, email
    FROM customers
    ORDER BY last_name"
end

def classical_playlists(db)
  # List tracks (Name + Composer) of the Classical playlist
  results = db.execute"
    SELECT tracks.composer, tracks.name
    FROM playlist_tracks
    JOIN tracks ON tracks.id = playlist_tracks.track_id
    JOIN playlists ON playlists.id = playlist_tracks.playlist_id
    WHERE playlists.name = 'Classical'
    "
    results
end

def top_artists_in_playlists(db)
  #List the 10 artists mostly listed in all playlists
  results = db.execute"
    SELECT artists.name, COUNT(*)
    AS occurrences
    FROM artists
    JOIN albums ON artists.id = albums.artist_id
    JOIN tracks ON albums.id = tracks.album_id
    JOIN playlist_tracks ON tracks.id = playlist_tracks.track_id
    GROUP BY artists.name
    ORDER BY occurrences DESC
    LIMIT 10"

    results
end

def purchases(db)
  #List the tracks which have been purchased at least twice, ordered by number of purchases
  results = db.execute"
    SELECT tracks.name, COUNT(*) AS purchases
    FROM tracks
    JOIN invoice_lines ON tracks.id = invoice_lines.track_id
    GROUP BY tracks.name
    HAVING purchases >= 2
    ORDER BY purchases DESC"
end

p purchases(db)
