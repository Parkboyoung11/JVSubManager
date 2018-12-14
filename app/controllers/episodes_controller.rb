class EpisodesController < ApplicationController
  def getEpisodes
    movie_id = params[:movie_id]
    episodeSArray = Episode.where(movie_id: movie_id)
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

  def createEpisode
    episode = Episode.new(episode_params)
    if episode.save
      movie_id = params[:movie_id]
      Movie.find_by(id: movie_id).touch
      respond_to do |format|
        format.html do
          render html: "xong eposide"
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

  private

  def episode_params
    params.permit(:movie_id, :name, :image, :video)
  end
end
