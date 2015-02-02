class Post
  attr_reader :title, :slug, :date, :path

  def initialize(title:, slug:, date:, path:)
    @title = title
    @slug = slug
    @date = date
    @path = path
  end

  def markdown
    File.new(@path).read
  end

  def content
    renderer.render(markdown).html_safe
  end

  private

  def renderer
    Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true)
  end
end
