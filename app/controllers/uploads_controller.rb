class UploadsController < ApplicationController
  def propose
  end

  def upload
    uploader = PostUploader.new
    uploader.store!(params[:post])

    push_to_github(uploader)
  end

  private

  def push_to_github(uploader)
    post = Post.new_from_path(uploader.path)
    GithubAgent.create_or_update(post)
  end
end
