Chist
=====

Share your chat with a unified style. Visit http://ichist.com

[![Code Climate](https://codeclimate.com/github/threefunkymonkeys/chist/badges/gpa.svg)](https://codeclimate.com/github/threefunkymonkeys/chist)
[![Build Status](https://travis-ci.org/threefunkymonkeys/chist.svg)](https://travis-ci.org/threefunkymonkeys/chist)


## Setup

1. Copy `config/settings.yml.sample` to `config/settings.yml` and add database parameters

2. Run `rake db:migrate` task to setup DB structure

3. Run the applications `rackup config.ru`

## Run Tests

1. Install necessary gems with `dep install -f .gems-test` (only the first time or if you need any update)

2. Edit `config/settings.yml` with test database config

3. Run `rake db:test:prepare` task to copy development DB structure

4. Run `rake test:all`

## License

<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a>.
