class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    sort = params[:sort] || session[:sort]
    case sort
    when 'title'
      ordering,@title_header = {:order => :title}, 'hilite'
    when 'release_date'
      ordering,@date_header = {:order => :release_date}, 'hilite'
    end
    @all_ratings = Movie.all_ratings
    @selected_ratings = params[:ratings] || session[:ratings] || {}
    
    if @selected_ratings == {}
      @selected_ratings = Hash[@all_ratings.map {|rating| [rating, rating]}]
    end
    
    if params[:sort] != session[:sort] or params[:ratings] != session[:ratings]
      session[:sort] = sort
      session[:ratings] = @selected_ratings
      redirect_to :sort => sort, :ratings => @selected_ratings and return
    end
    @movies = Movie.find_all_by_rating(@selected_ratings.keys, ordering)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  def search_tmdb
    @search = params["search"]["movie_search"]
    #binding.pry

    @movie_array = []

    if(@search.blank?)
      flash[:notice] = "Invalid search term"
      redirect_to movies_path
    else
      @matching_movies = Movie.find_in_tmdb(@search)
      if (@matching_movies.empty?)
        flash[:notice] = "No matching movies were found on TMdb"
        redirect_to movies_path
      else
        @matching_movies.each do |match|
          title = match.title
          id = match.id
          release_date = match.release_date
          hash = {:tmdb_id => id, :tmdb_title => title, :tmdb_rating => "PG", :tmdb_release_date => release_date}
          @movie_array << hash
        end
      end
    end
  end
  
  def add_tmdb
    if(params["tmdb_movies"] == nil || params["tmdb_movies"].empty?)
      flash[:notice] = "No movies selected"
      redirect_to movies_path
    else
      ids_array = params["tmdb_movies"].keys
      Movie::create_from_tmdb(ids_array)
      flash[:notice] = "Movies successfully added to Rotten Potatoes"
      redirect_to movies_path
    end
  end

end
