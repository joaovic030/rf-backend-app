DCMP = docker-compose
RAILS = bundle exec rails

#== DEVS ==================================================

up:
	${DCMP} up

down:
	${DCMP} down

start:
	RAILS_ENV=development bash ./server.sh

setup-queues-and-run:
    make sneakers
    make setup-rabbitmq

setup-rabbitmq:
	bundle exec rake rabbitmq:setup

sneakers:
	bundle exec rake sneakers:run

dbrenew:
	${RAILS} db:drop db:create db:migrate db:test:prepare

dbreseed:
	${RAILS} db:drop db:create db:migrate db:seed db:test:prepare

rebuild:
	${DCMP} up

create-env-file:
	cp .example.env .env

