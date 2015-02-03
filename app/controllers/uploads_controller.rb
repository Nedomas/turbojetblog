class UploadsController < ApplicationController
  extend Memoist

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
    github.repos.contents.create(
      ENV['GH_USERNAME'],
      ENV['GH_REPO'],
      post.path,
      path: post.path,
      message: "Add post: #{post.title}",
      content: post.content,
    )
  rescue Github::Error::UnprocessableEntity
    post = Post.new_from_path(uploader.path)

    existing_file = github.repos.contents.find(
      ENV['GH_USERNAME'],
      ENV['GH_REPO'],
      post.path,
      path: post.path,
    )

    github.repos.contents.update(
      ENV['GH_USERNAME'],
      ENV['GH_REPO'],
      post.path,
      path: post.path,
      message: "Update post: #{post.title}",
      content: post.content,
      sha: existing_file.sha,
    )
  end

  memoize def github
    Github.new(basic_auth: "#{ENV['GH_USERNAME']}:#{ENV['GH_PASSWORD']}")
  end
end
