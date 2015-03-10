# EthnicChic


## Setup database

```
bundle exec rake db:create
bundle exec rake railties:install:migrations
bundle exec rake db:migrate
bundle exec rake db:seed
```

## Reset the local database

```
bundle exec rake db:drop db:create db:migrate db:seed
```

```
rake ethnicchic:update_alt_text - rake task for update alt text in product's image
```