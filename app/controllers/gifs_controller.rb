class GifsController < ApplicationController

  before_action :authorize

  def index
    @gifs = Gif.where('image IS NOT null').order('created_at DESC')
  end

  def new
    @gif = Gif.new
  end

  def create
    @gif = Gif.new(gif_params.except(:remote_image_url))
    @gif.user = current_user

    if @gif.save
      GifImageUploadWorker.perform_async(@gif.id, gif_params[:remote_image_url])
      flash[:success] = "You're image is being processed"
      redirect_to gifs_path
    else
      flash.now[:error] = @gif.errors.full_messages.to_sentence
      render :new
    end
  end

private

  def gif_params
    params.require(:gif).permit(:title, :remote_image_url, :image)
  end
end
