class GifImageUploadWorker
  include Sidekiq::Worker

  def perform(gif_id, url)
    gif = Gif.find(gif_id)
    gif.remote_image_url = url
    gif.save
  end
end