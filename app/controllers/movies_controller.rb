class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if (!params[:sort] && !params[:ratings])
       if (session[:sort] && session[:ratings])
          flash.keep
          redirect_to movies_path(:sort => session[:sort], :ratings => session[:ratings])
       end
    end

    if params[:sort]
       session[:sort] = params[:sort]
    end
    
    if params[:ratings]
       session[:ratings] = params[:ratings]
    end
       
    @all_ratings = Movie.all_ratings
    @checked = @all_ratings
    @action = session[:sort]
    if !params[:ratings].nil?
       @checked = session[:ratings].keys
    end
    if @action   
       if @action == 'title'
          @class_title = 'hilite'
          @movies =Movie.where(:rating => @checked).order('title')
       else
          @class_date = 'hilite'
          @movies =Movie.where(:rating => @checked).order("release_date")
       end
    elsif session[:ratings]
      @movies = Movie.find(:all, rating: @checked)
    else
      @movies = Movie.find(:all)
    end 
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

end
