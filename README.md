Chist
=====

Share your chat with a unified style

## Setup

1. Copy `config/settings.yml.sample` to `config/settings.yml` and add database parameters

2. Run `rake db:generate` task

3. Run the applications `rackup config.ru`

## Run Tests

1. Edit `config/settings.yml` with test database config

2. Run `rake db:generate test` task to generate tables

3. Run `rake test:all`
