class MoviesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def getAnimeList
    language = params[:sub]
    newAnimes = Movie.where(language: language).order(created_at: :desc).limit(Settings.number_list_anime)
    trendAnimes = Movie.where(language: language).order(views: :desc).limit(Settings.number_list_anime)
    randomAnimes = Movie.where(language: language).order(Settings.random_function).limit(Settings.number_list_anime)

    if params[:key] && user = User.find_by(api_key: params[:key])
      user_id = user.id
      newAnimeArray = refactorArrayWithKey(newAnimes, user_id)
      trendAnimesArray = refactorArrayWithKey(trendAnimes, user_id)
      randomAnimesArray = refactorArrayWithKey(randomAnimes, user_id)
    else
      newAnimeArray = refactorArrayNoKey(newAnimes)
      trendAnimesArray = refactorArrayNoKey(trendAnimes)
      randomAnimesArray = refactorArrayNoKey(randomAnimes)
    end

    jsonAnimeList = (newAnimeArray + trendAnimesArray + randomAnimesArray).to_json
    respond_to do |format|
        format.json do
          render json: jsonAnimeList
        end
        format.html do
          render html: jsonAnimeList
        end
    end
  end

  def createDB
    movie = Movie.new(movie_params)
    if movie.save
      respond_to do |format|
        format.html do
          render html: "xong"
        end
      end
    else
      respond_to do |format|
        format.html do
          render html: "loi!"
        end
      end
    end
  end

  def favoriteHanding
    movie_id = params[:movie_id]
    like = params[:like]
    if user = User.find_by(api_key: params[:key])
      user_id = user.id
      if like == "true"
        Favorite.create(user_id: user_id, movie_id: movie_id)
      else like == "false"
        Favorite.where(user_id: user_id, movie_id: movie_id).destroy_all
      end
    end
  end

  def getFavoriteList
    if user = User.find_by(api_key: params[:key])
      if favorites = Favorite.where(user_id: user.id)
        moiveIDArray = favorites.map {|favorite| favorite.movie_id}
        originMoviewArray = Movie.where(id: moiveIDArray, language: params[:sub])
        newMovieArray = refactorArrayFavorite(originMoviewArray)
        jsonMovieArray = newMovieArray.to_json
        respond_to do |format|
          format.json do
            render json: jsonMovieArray
          end
          format.html do
            render html: jsonMovieArray
          end
        end
      end
    end
  end

  def refactorArrayWithKey(originArray, user_id)
    newArray = originArray.map do |u|
      if Favorite.where(:user_id => user_id, :movie_id => u.id).any?
        { :id => u.id, :description => u.description, :image => u.image, :name => u.name, :liked => :true }
      else
        { :id => u.id, :description => u.description, :image => u.image, :name => u.name, :liked => :flase }
      end
    end
    return newArray
  end

  def refactorArrayNoKey originArray
    newArray = originArray.map do |u|
        { :id => u.id, :description => u.description, :image => u.image, :name => u.name, :liked => :flase }
    end
    return newArray
  end

  def refactorArrayFavorite originArray
    newArray = originArray.map do |u|
        { :id => u.id, :description => u.description, :image => u.image, :name => u.name, :liked => :true }
    end
    return newArray
  end

  private

  def movie_params
    params.permit(:name, :description, :image, :language)
  end
end
