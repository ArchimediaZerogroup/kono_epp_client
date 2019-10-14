Gem::Specification.new do |s|
    s.name        = 'kono_epp_client'
    s.version     = '0.0.3'
    s.date        = '2019-10-08'
    s.summary     = "Kono Epp client"
    s.description = "A simple EPP Client"
    s.authors     = ["Fabio Bonelli","Jury Ghidinelli"]
    s.email       = 'jury@archimedianet.it'
    s.files       = ["lib/kono_epp_client.rb"]
    s.homepage    = 'https://github.com/ArchimediaZerogroup/kono_epp_client'
    s.license     = 'MIT'


    files = `git ls-files -z`.split("\x0")
    s.files = files.grep(%r{^(app|config|db|lib|vendor/assets)/}) + ['README.rdoc', 'Rakefile', 'MIT-LICENSE']
    s.test_files = files.grep(%r{^(spec)/})

  end