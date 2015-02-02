class PostsController < ApplicationController
  def index
    @posts = Dir.glob('public/raw_posts/*.md').map do |file_path|
      post_from_path(file_path)
    end
  end

  def show
    file_path = Dir.glob("public/raw_posts/*-#{params[:slug]}.md").first
    raise 'No such file' unless file_path

    @post = post_from_path(file_path)
  end

  private

  def post_from_path(path)
    filename = Pathname.new(path).basename.to_s
    _, dashed_date, dashed_title = filename.match(/(\d{4}-\d{2}-\d{2})-(.*).md/).to_a

    OpenStruct.new(
      title: dashed_title.titleize,
      slug: dashed_title,
      date: dashed_date,
      markdown: -> { File.new(path).read },
    )
  end
end
