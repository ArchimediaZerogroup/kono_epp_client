# kono_epp_client
A simple EPP Client



## Development
Build dell'immagine di docker
```shell
docker compose build
```
Installazione dipendenze
```shell
docker compose run app bundle
```
Run rspec
```shell
docker compose run app bundle exec rspec
```

Oppure con Makefile:
```shell
make
```