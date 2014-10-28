#spec/models/movie_rspec.rb:

RSpec.describe Movie, :type => :model do

  describe 'searching Tmdb by keyword' do
    it 'should return a list of movies' do
      movie_response = Movie::find_in_tmdb("Lethal Weapon")
      if(movie_response[2].title == "Lethal Weapon 2")
        equal = true
      else 
        equal = false
      end
      expect(equal).to eq true
    end
  end
    
  describe 'adding title to database' do
    context 'with multiple selections' do
      it 'should add title to database' do
        Movie::create_from_tmdb(["45535", "1"])
        fatal_exists = Movie.exists?(title: 'Fatal')
        expect(fatal_exists).to eq true
      end
    end

    context 'with no selections' do
      it 'should return false' do
        create = Movie::create_from_tmdb([])
        if(create == false)
          equal = true
        else
          equal = false
        end
        expect(equal).to eq false
      end
    end
  end
end

