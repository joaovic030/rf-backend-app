DCMP = docker-compose
RAILS = bundle exec rails

#== DEVS ==================================================

up:
	${DCMP} up

down:
	${DCMP} down

start:
	RAILS_ENV=development bash ./server.sh

install:
	sudo apt install libpq-dev || brew install postgres
	gem install bundler
	bundle lock --add-platform x86_64-linux ruby x86-mingw32 x86-mswin32 x64-mingw32 java
	bundle install

setup-queues-and-run:
	make sneakers-run
	make setup-rabbitmq

setup-rabbitmq:
	bundle exec rake rabbitmq:setup

sneakers-run:
	bundle exec rake sneakers:run

seed-players:
	rake data_from_api:load
