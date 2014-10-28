# Completed step definitions for basic features: AddMovie, ViewDetails, EditMovie 

Given /^I am on the RottenPotatoes home page$/ do
  visit movies_path
 end


 When /^I have added a movie with title "(.*?)" and rating "(.*?)"$/ do |title, rating|
  visit new_movie_path
  fill_in 'Title', :with => title
  select rating, :from => 'Rating'
  click_button 'Save Changes'
 end

 Then /^I should see a movie list entry with title "(.*?)" and rating "(.*?)"$/ do |title, rating| 
   result=false
   all("tr").each do |tr|
     if tr.has_content?(title) && tr.has_content?(rating)
       result = true
       break
     end
   end  
   assert result
 end

 When /^I have visited the Details about "(.*?)" page$/ do |title|
   visit movies_path
   click_on "More about #{title}"
 end

Then /^(?:|I )should see "([^"]*)"$/ do |text|
  if page.respond_to? :should
    expect(page).to have_content(text)
  else
    assert page.has_content?(text)
  end
end

 When /^I have edited the movie "(.*?)" to change the rating to "(.*?)"$/ do |movie, rating|
  click_on "Edit"
  select rating, :from => 'Rating'
  click_button 'Update Movie Info'
 end


# New step definitions to be completed for HW3. 
# Note that you may need to add additional step definitions beyond these


# Add a declarative step here for populating the DB with movies.

Given /the following movies have been added to RottenPotatoes:/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create(movie)
  end
  assert movies_table.hashes.size == Movie.all.count
end

When /^I have opted to see movies rated: "(.*?)"$/ do |arg1|
  page.uncheck("ratings_G")
  page.uncheck("ratings_PG")
  page.uncheck("ratings_PG-13")
  page.uncheck("ratings_R")

  stringArray = arg1.split(", ")

  stringArray.each do |x|
    string = "ratings_"
    string << (x)
    page.check(string)
  end
  click_button('Refresh')
end

Then /^I should see only movies rated "(.*?)"$/ do |arg1|
  ratingMatch = true
  ratingsArray = arg1.split(", ")

  ratings = {"G" => false, "PG"=> false, "PG-13" => false, "R" => false}

  ratingsArray.each do |x|
    if(ratingsArray == "G")
     ratings["G"] = true
    elsif(ratingsArray == "PG")
      ratings["PG"] = true
    elsif(ratingsArray == "PG-13")
      ratings["PG-14"] = true
    elsif(ratingsArray == "R")
      ratings["R"] = true
    end
  end


  movieString = page.all('table#movies tr').map(&:text)
  movieString = movieString[0]

  movieList = movieString.split(" ")

  ratings.each do |key, value|
    if ((value == false) && (movieList.include? key))         
      ratingMatch = false  
    end    
  end
 
  assert ratingMatch
end

Then /^I should see all of the movies$/ do
  #get number of rows in the movies table
  rows = Movie.all.count
  size = page.all('table#movies tr').size - 1

  assert (rows == size)
end


When /^I have clicked the "(.*)" link/ do |link|
  click_link(link)
end

Then /^I should see "(.*)" before I see "(.*)"/ do |movie1, movie2|
  inOrder = false

  movieString = page.all('table#movies').map(&:text)
  movieString = movieString[0]

  movieList = movieString.split(" ")
  
  movie1Index = movieList.index(movie1)
  movie2Index = movieList.index(movie2)

  if(movie1Index < movie2Index)
    inOrder = true
  end

  assert inOrder
end



