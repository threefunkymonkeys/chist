Chist
=====

Share your chat with a unified style

## Setup

1. Copy `config/settings.yml.sample` to `config/settings.yml` and add database parameters

2. Run `rake db:migrate` task to setup DB structure

3. Run the applications `rackup config.ru`

## Run Tests

1. Install necessary gems with `dep install -f .gems-test` (only the first time or if you need any update)

2. Edit `config/settings.yml` with test database config

3. Run `rake db:test:prepare` task to copy development DB structure

4. Run `rake test:all`
