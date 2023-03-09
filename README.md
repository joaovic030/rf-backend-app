# RF-Backend-App

# Requirements
[![Ruby](https://img.shields.io/badge/ruby-v3.1.2%2B-blue.svg)](https://www.ruby-lang.org/en/news/2022/04/12/ruby-3-1-2-released/)
[![Rails](https://img.shields.io/badge/rails-v7.0.4.2%2B-blue.svg)](https://github.com/rails/rails/tree/v7.0.4.2)

## Development environment

1. Download and install dependencies

```sh
bundle install
```
2. Replace or create you master.key with this value (_for the purpose of this challenge I will let it here (**not recommended**)_)
```sh
7b225d11913d7f66c5e64aff4fa525fb
```
3. Start the _containers_

```sh
make up
```

4. Start sneakers, generate and bind our rabbitmq queues

```sh
make setup-queues-and-run
```

5. Start the rails server
```sh
make start # or you just use rails server :D
```
6. You should also seed the data. Players and teams
```sh
make seed-players
```
## Utils and tests

- There is a linter, even though didnt have the time to fix its design code suggestions. Put it here as a good practice.

```sh
rubocop
```

- Delete RabbitMQ queues and _exchanges_, defined in `config/rabbitmq.yml`.

```sh
make prune-rabbitmq
```

- To just create RabbitMQ queues and _exchanges_, defined in `config/rabbitmq.yml`. But I advise to use the command in the startup section in the begging of this file.

```sh
make setup-rabbitmq
```

- Execute all the tests.

```sh
rspec
```
