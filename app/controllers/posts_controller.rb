class PostsController < ApplicationController
  def index
    @posts = Dir.glob('public/raw_posts/*.md').map do |file_path|
      filename = Pathname.new(file_path).basename.to_s
      _, dashed_date, dashed_title = filename.match(/(\d{4}-\d{2}-\d{2})-(.*).md/).to_a

      OpenStruct.new(
        title: dashed_title.titleize,
        slug: dashed_title,
        date: dashed_date,
      )
    end
  end

  def show
  end
end
