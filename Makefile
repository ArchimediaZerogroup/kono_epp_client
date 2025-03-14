vpath %.touch ./tmp

test: install.touch
	docker compose run --rm --remove-orphans app bundle exec rspec $(spec)

install.touch: Gemfile image_build.touch
	docker compose run app bundle
	touch tmp/install.touch

image_build.touch: Dockerfile
	mkdir -p tmp
	docker compose build
	touch tmp/image_build.touch
