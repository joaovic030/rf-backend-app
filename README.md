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
> If needed, can run `make install` to install some dependencies regarding postgres and bundler

4. Start sneakers

```sh
rake sneakers:run
```

5. Bind our rabbitmq queues

```sh
rake rabbitmq:setup
```

6. Run the create and migrate:
```sh
rails db:create db:migrate
```

7. Start the rails server
```sh
rails s
```
8. You should also seed the data. Players and teams
```sh
make seed-players
```
9. It is not a step, but, for testing, can just run `rspec` and see the coverage in:
`coverage/index.html` for a better visual experience.
**After those instructions, everything should be able to work**

## Utils and tests

- There is a linter, even though didnt have the time to fix its design code suggestions. Put it here as a good practice.

```sh
rubocop
```

- To just create RabbitMQ queues and _exchanges_, defined in `config/rabbitmq.yml`. But I advise to use the command in the startup section in the begging of this file.

```sh
make setup-rabbitmq
```

- Execute all the tests.

```sh
rspec
```

## Quick explanation about the project and points to improve
- A pub/sub pattern with Publishers and Workers for each resource, based on the business logic.
- The task responsible for deleting notifications older then one week I delegated for my message broker process. After creating notification, is submitted the notification_id as payload to a delayed queue (The delay could be 7.days or 8.days, but I let 1.min to ease the test :D)
- I recommend to create your own user with a valid email to you see the email coming into your inbox.
    - `rails console`, `User.create(name: 'YourName', email: 'valid@email.com', password: '123456')`
- The pagination is in the final of the Players page.
- The notification is sent every time a Player is updated, then the emails are sent to the recipients who are subscribed to the player.

**To improve**
- Yes, I could implement a validation or namespace for the simple user, and the admin one. Permissions and so on.
- There are some services and classes that can be refactored, apply an interface, inheritance, and just let the child class implement the common and necessary methods.
- Implement x-dead-letter -> to generate retry and error queue. I implemented it once but got some errors, corrected them and the execution life cycle changed, and appeared more errors, so I regretted in order to correct and make things work.

## Choices and trade-offs

**GraphQL:**
* Making multiple queries as once.
* Forcing consumers to select the fields they need, thus improve performance in different devices.
* Fetching related resources as part of parent resources.
* Easy paginating resources, using default properties or your own.
* Strongly-typing the resources you expose.
* With Playground we can se the documentation generated for our API. There's no need to immediately look for a separate documentation.

**Sneakers**
- I prefer to use Sneakers since it has more specific purpose which is to consume a message as a background job.
- Widely used with RabbitMQ and Bunny, since itself is built with Bunny.

**RabbitMQ**
- Open source and feature-rich.
- One of the most used/deployed message broker system.
- Multiple messaging.
- Message queuing.
- Really good for a reactive/event-driven approach.

**PostgreSQL**
- One of the most used, resilient and strong RDBMS.
- Our data is well defined, we have appropriated schema and associations and there is no need to choose a generalist approach, as example - MongoDB.
