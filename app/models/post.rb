class Post
  attr_reader :title, :slug, :date, :path

  def initialize(title:, slug:, date:, path:)
    @title = title
    @slug = slug
    @date = date
    @path = path

    clean_path!
  end

  def self.new_from_path(path)
    filename = Pathname.new(path).basename.to_s
    _, dashed_date, dashed_title = filename.match(/(\d{4}-\d{2}-\d{2})-(.*).md/).to_a

    new(
      title: dashed_title.titleize,
      slug: dashed_title,
      date: dashed_date,
      path: path,
    )
  end

  def markdown
    File.new(@path).read
  end

  def content
    renderer.render(markdown).html_safe
  end

  def existing_sha
    GithubAgent.find(path).sha
  end

  private

  def renderer
    Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true)
  end

  def clean_path!
    @path = Pathname.new(Rails.root.join(@path))
      .relative_path_from(Rails.root).to_s
  end
end
