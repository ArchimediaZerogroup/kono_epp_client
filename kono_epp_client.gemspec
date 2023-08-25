Gem::Specification.new do |s|
    s.name        = 'kono_epp_client'
    s.version     = '0.1.0'
    s.date        = '2019-10-08'
    s.summary     = "Kono Epp client"
    s.description = "A simple EPP Client"
    s.authors     = ["Fabio Bonelli","Jury Ghidinelli","Marino Bonetti"]
    s.email       = ['jury@archimedianet.it','marinobonetti@gmail.com']
    s.files       = ["lib/kono_epp_client.rb"]
    s.homepage    = 'https://github.com/ArchimediaZerogroup/kono_epp_client'
    s.license     = 'MIT'


    files = `git ls-files -z`.split("\x0")
    s.files = files.grep(%r{^(app|config|db|lib|vendor/assets)/}) + ['README.md']
    s.test_files = files.grep(%r{^(spec)/})

    s.add_dependency 'activesupport','>= 5.2'
    s.add_dependency 'rexml'
    s.add_dependency 'nokogiri','>= 1.10'

  end