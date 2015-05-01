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
bundle exec rake db:reset
```

```
rake ethnicchic:update_alt_text - rake task for update alt text in product's image
```
## Import database from cloud66 locally

Download the database [from the backups](https://app.cloud66.com/stacks/20783/managed_backups/1389)
