class MoviesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def getAnimeList
    language = params[:sub]
    newAnimes = Movie.where(language: language).order(created_at: :desc).limit(Settings.number_list_anime)
    trendAnimes = Movie.where(language: language).order(views: :desc).limit(Settings.number_list_anime)
    randomAnimes = Movie.where(language: language).order(created_at: :desc).offset(Settings.number_list_anime).limit(Settings.number_list_anime)

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
        respond_to do |format|
          format.json do
            render json: {
                id: movie_id,
                liked: :true
            }.to_json
          end
        end
      else like == "false"
        Favorite.where(user_id: user_id, movie_id: movie_id).destroy_all
        respond_to do |format|
          format.json do
            render json: {
                id: movie_id,
                liked: :false
            }.to_json
          end
        end
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

  def getMoreList
    language = params[:sub]
    offset = Settings.number_list_anime * (params[:page].to_i + 2)
    moreAnimes = Movie.where(language: language).order(created_at: :desc).offset(offset).limit(Settings.number_list_anime)

    if params[:key] && user = User.find_by(api_key: params[:key])
      user_id = user.id
      moreAnimesArray = refactorArrayWithKey(moreAnimes, user_id)
    else
      moreAnimesArray = refactorArrayNoKey(moreAnimes)
    end

    jsonAnimeList = moreAnimesArray.to_json
    respond_to do |format|
      format.json do
        render json: jsonAnimeList
      end
      format.html do
        render html: jsonAnimeList
      end
    end
  end

  def searchAnime
    language = params[:sub]
    searchAnimes = Movie.where("lower(name) LIKE ?", "%#{params[:name].downcase}%").where(language: language).limit(Settings.number_list_anime)

    if params[:key] && user = User.find_by(api_key: params[:key])
      user_id = user.id
      searchAnimesArray = refactorArrayWithKey(searchAnimes, user_id)
    else
      searchAnimesArray = refactorArrayNoKey(searchAnimes)
    end

    searchAnimesList = searchAnimesArray.to_json
    respond_to do |format|
      format.json do
        render json: searchAnimesList
      end
      format.html do
        render html: searchAnimesList
      end
    end
  end

  def refactorArrayWithKey(originArray, user_id)
    newArray = originArray.map do |u|
      if Favorite.where(:user_id => user_id, :movie_id => u.id).any?
        { :id => u.id, :description => u.description, :image => u.image, :name => u.name, :liked => :true }
      else
        { :id => u.id, :description => u.description, :image => u.image, :name => u.name, :liked => :false }
      end
    end
    return newArray
  end

  def refactorArrayNoKey originArray
    newArray = originArray.map do |u|
        { :id => u.id, :description => u.description, :image => u.image, :name => u.name, :liked => :false }
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
