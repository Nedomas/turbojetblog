class PostUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    # that is public/posts
    'raw_posts'
  end
end
