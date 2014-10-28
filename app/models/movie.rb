class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 R)
  end

  def Movie::find_in_tmdb(search_term)
    Tmdb::Api.key("f4702b08c0ac6ea5b51425788bb26562")
    matching_movies = Tmdb::Movie.find(search_term)
    return matching_movies
  end

  def Movie::create_from_tmdb(tmdb_id)
    tmdb_id.each do |id|
      movie_to_add = Tmdb::Movie.detail(id)
      new_title = movie_to_add["title"]
      new_release_date = movie_to_add["release_date"]
      new_movie = {"title" => new_title, "rating" => "PG", "release_date" => new_release_date}
      Movie.create!(new_movie)
    end
  end
end
