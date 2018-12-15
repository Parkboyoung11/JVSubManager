class EpisodesController < ApplicationController
  def index
    @movie_id = params[:movie_id]
    @episodes = Episode.where(movie_id: @movie_id)
    render "movies/episodes/index"
  end

  def new
    @episode = Episode.new
    @movie_id = params[:movie_id]
    render "movies/episodes/new"
  end

  def create
    if current_admin.present?
      episode = Episode.new(episode_params_origin)
      if episode.save
        flash[:success] = "Create Episode Success"
        redirect_to movie_episodes_url(params[:episode][:movie_id])
      else
        flash[:error] = "Some field invalid"
        render "movies/episodes/new"
      end
    end
  end

  def edit
    @episode = Episode.find(params[:id])
    render "movies/episodes/edit"
  end

  def update
    if current_admin.present?
      @episode = Episode.find(params[:id])
      if @episode.update_attributes(episode_params_origin)
        flash[:success] = "Update Successfully"
      else
        flash[:error] = "Error"
      end

      render "movies/episodes/edit"
    end
  end

  def destroy
    if current_admin.present?
      episode = Episode.find(params[:id])
      movie_id = episode.movie_id
      episode.destroy
      flash[:success] = "Movie Deleted"
      redirect_to  movie_episodes_url(movie_id)
    end
  end

  def getEpisodes
    movie_id = params[:movie_id]
    episodeSArray = Episode.where(movie_id: movie_id).order(movie_id: :asc)
    if user = User.find_by(api_key: params[:key])
      user_id = user.id
      newArray = episodeSArray.map do |u|
        if (watch = Watching.where(:user_id => user_id, :episode_id => u.id)).any?
          { :id => u.id, :name => u.name, :image => u.image, :link => u.video, :watch => watch.first.seconds }
        else
          { :id => u.id, :name => u.name, :image => u.image, :link => u.video, :watch => 0 }
        end
      end
    else
      newArray = episodeSArray.map do |u|
        { :id => u.id, :name => u.name, :image => u.image, :link => u.video, :watch => 0 }
      end
    end

    jsonEpisodeList = newArray.to_json

    Movie.find_by(id: movie_id).increment!(:views)

    respond_to do |format|
      format.json do
        render json: jsonEpisodeList
      end
      format.html do
        render html: jsonEpisodeList
      end
    end
  end

  def setWatchedTime
    if user = User.find_by(api_key: params[:key])
      user_id = user.id
      episode_id = params[:episode_id]
      if (watch = Watching.where(:user_id => user_id, :episode_id => episode_id)).any?
        watch.first.update_attribute(:seconds, params[:watch])
      else
        unless Watching.create(user_id: user_id, episode_id: episode_id, seconds: params[:watch]).valid?
          respond_to do |format|
            format.json do
              render json: {
                  status: 500,
                  message: "Something went wrong!"
              }.to_json
            end
          end
          return
        end
      end
      movie_id = Episode.find_by(id: episode_id).movie_id
      unless History.where(:user_id => user_id, :movie_id => movie_id).any?
        History.create(user_id: user_id, movie_id: movie_id)
      end

      respond_to do |format|
        format.json do
          render json: {
              status: 200,
              id: episode_id.to_i,
              watch: params[:watch].to_i
          }.to_json
        end
      end
    else
      respond_to do |format|
        format.json do
          render json: {
              status: 500,
              message: "Something went wrong!"
          }.to_json
        end
      end
    end
  end

  private

  def episode_params_origin
    params.require(:episode).permit(:movie_id, :name, :image, :video)
  end
end
