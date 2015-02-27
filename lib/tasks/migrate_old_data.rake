task :migrate_old_data => :environment do
  desc 'Migrate old data from ethnicchic'

  puts 'Started migration'
  MigrateOldDbToEthnicchick2.new.exec_migration(ActiveRecord::Base.connection, :up)
  puts 'Migrated successfully!'
  ActiveRecord::Base.connection.execute("delete from schema_migrations where version='20150225083011';")
  puts 'Schema migration 20150225083011 deleted!'

  # renew schema
  Rake::Task["db:schema:dump"].execute
  puts "Schema dumped!"

  puts 'Started VariantPricesMigration'
  VariantPricesMigration.new.migrate
  puts 'Finished VariantPricesMigration'

  puts 'Started BrandsMigration'
  BrandsMigration.new.migrate
  puts 'Finished BrandsMigration'
end