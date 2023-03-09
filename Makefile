DCMP = docker-compose
RAILS = bundle exec rails

#== DEVS ==================================================

up:
	${DCMP} up

down:
	${DCMP} down

start:
	RAILS server

setup-queues-and-run:
	make sneakers-run
	make setup-rabbitmq

setup-rabbitmq:
	bundle exec rake rabbitmq:setup

sneakers-run:
	bundle exec rake sneakers:run

seed-players:
	rake data_from_api:load
