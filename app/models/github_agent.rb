class GithubAgent
  class << self
    extend Memoist

    def find(path)
      github.repos.contents.find(*login, path, path: path)
    end

    def create_or_update(post)
      create(post)
    rescue Github::Error::UnprocessableEntity
      update(post)
    end

    private

    def create(post)
      github.repos.contents.create(*login, post.path,
        path: post.path,
        message: "Add post: #{post.title}",
        content: post.markdown,
      )
    end

    def update(post)
      github.repos.contents.update(*login, post.path,
        path: post.path,
        message: "Update post: #{post.title}",
        content: post.markdown,
        sha: post.existing_sha,
      )
    end

    memoize def github
      Github.new(basic_auth: "#{ENV['GH_USERNAME']}:#{ENV['GH_PASSWORD']}")
    end

    def login
      [ENV['GH_USERNAME'], ENV['GH_REPO']]
    end
  end
end
