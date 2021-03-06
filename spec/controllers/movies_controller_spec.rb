require 'rails_helper'

RSpec.describe MoviesController, :type => :controller do
    
  describe 'searching TMDb' do
    it 'should redirect to the movies path if the search is blank' do
      post :search_tmdb, {"search" => ""}
      expect(response).to have_http_status(302)
    end

    it 'should redirect to the movies path if the search is bad' do
      post :search_tmdb, {"search" => "alkdjfkladjk;ladjfkl;adj;lfj"}
      expect(response).to have_http_status(302)
    end

    it 'should render the search_tmdb view if the search is successful' do
      post :search_tmdb, {"search" => {"movie_search" => "Fatal"}}
      expect(response).to render_template("search_tmdb")
    end

  end

  describe 'adding from TMdb' do

    it 'should redirect to the movies path when complete' do
      post :add_tmdb, {"tmdb_movies"=>{"45535"=>"1"}}
      expect(response).to have_http_status(302)
    end

    it 'should add it to the database with a valid entry' do
      post :add_tmdb, {"tmdb_movies"=>{"45535"=>"1"}}
      fatal_exists = Movie.exists?(title: 'Fatal')
      expect(fatal_exists).to eq true
    end

    it 'should not add to the database with an invalid entry' do
      post :add_tmdb
      fatal_exists = Movie.exists?(title: 'Fatal')
      expect(fatal_exists).to eq false
      expect(response).to have_http_status(302)
    end
  end

  describe 'showing data' do

    it 'should render the show view for the given index' do
      Movie.create!({"title" => 'Fatal', "release_date" => "10/23/2006", "rating" => "R"})
      get :show,  {"id" =>  1}
      expect(response).to render_template('show')
    end
  end

end
