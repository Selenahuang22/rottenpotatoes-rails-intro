class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    checked_ratings = params[:ratings]
    
    if checked_ratings == nil
      @ratings_to_show = []
    else
      @ratings_to_show = checked_ratings.keys
    end

    @all_ratings = Movie.all_ratings
    @movies = Movie.with_ratings(checked_ratings)

    
    @sorted = params[:sorted] || session[:sorted]
    session[:ratings] = session[:ratings] || {'G'=>'', 'PG'=>'','PG-13'=>'','R'=>''}
    @t_param = params[:ratings] || session[:ratings]
    session[:sorted] = @sorted
    session[:ratings] = @t_param

    @aclass1 = ""
    @aclass2 = ""
    if @sorted == 'title'
      @aclass1 = 'hilite p-3 mb-2 bg-warning text-dark'
      @movies = Movie.where(rating: session[:ratings].keys).order('title')
    elsif @sorted == 'release_date'
      @aclass2 = 'hilite p-3 mb-2 bg-warning text-dark'
      @movies = Movie.where(rating: session[:ratings].keys).order('release_date')
    end
  
    if (params[:sorted].nil? and !(session[:sorted].nil?)) or (params[:ratings].nil? and !(session[:ratings].nil?))
      flash.keep
      redirect_to movies_path(sorted: session[:sorted], ratings: session[:ratings])
    end

  end


  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
