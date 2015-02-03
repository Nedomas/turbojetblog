class PostsController < ApplicationController
  def index
    @posts = Dir.glob('public/raw_posts/*.md').map do |file_path|
      Post.new_from_path(file_path)
    end

    @posts.sort_by!(&:date).reverse!
  end

  def show
    file_path = Dir.glob("public/raw_posts/*-#{params[:slug]}.md").first
    raise 'No such file' unless file_path

    @post = Post.new_from_path(file_path)
  end
end
