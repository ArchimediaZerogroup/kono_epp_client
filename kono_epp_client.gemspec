require_relative "lib/kono_epp_client/version"

Gem::Specification.new do |s|
  s.name = 'kono_epp_client'
  s.version = KonoEppClient::VERSION
  s.date = '2019-10-08'
  s.summary = "Kono Epp client"
  s.description = "A simple EPP Client"
  s.authors = ["Fabio Bonelli", "Jury Ghidinelli", "Marino Bonetti"]
  s.email = ['jury@archimedianet.it', 'marinobonetti@gmail.com']
  s.homepage = 'https://github.com/ArchimediaZerogroup/kono_epp_client'
  s.license = 'MIT'
  s.required_ruby_version = ">= 2.7"

  s.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*[
          "bin/", "test/", "spec/", "features/",
          ".git", ".gitlab-ci.yml", "appveyor", "Gemfile",
          "cog.toml", "docker-compose.yml", "Dockerfile",
          ".rspec", ".rubocop.yml"
        ])
    end
  end

  files = `git ls-files -z`.split("\x0")
  s.test_files = files.grep(%r{^(spec)/})

  s.add_dependency 'activesupport', '>= 5.2'
  s.add_dependency 'rexml'
  s.add_dependency 'nokogiri', '>= 1.10'
  s.add_dependency 'zeitwerk'

  s.add_development_dependency "rspec"
  s.add_development_dependency "super_diff"
  s.add_development_dependency "rspec-html-matchers"
  s.add_development_dependency 'rspec-snapshot'
  s.add_development_dependency 'debug'
  s.add_development_dependency 'factory_bot'

end