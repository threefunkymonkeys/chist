export SESSION_SECRET="78ed3d745964e4e9be0c4b61f9ab36869d8e911a7048fb0f357c31eed73f11e9b0acbb03da27503c690c75e409e5b84cc41fe58ca457f63cc330811cb12aaa0a"
export DATABASE_HOST=localhost
export DATABASE_PORT=5432
export DATABASE_NAME=chist_test
export DATABASE_USER=postgres
export SITE_URL=http://localhost:9292
export MAILER_FROM_EMAIL=[example@example.com]
export MAILER_FROM_NAME=[Example]
export MM_URGENT_QUOTA=[50]
export MM_NORMAL_QUOTA=[25]
export MM_LOW_QUOTA=[5]
export MM_NORMAL_SLEEP=[1]
export MM_LOW_SLEEP=[2]
export MM_SLEEP=[5]
export MAILER_ADAPTER=smtp
export MANDRIL_API_KEY="12345"
export RACK_ENV=test

rake db:migrate
rake test:all
