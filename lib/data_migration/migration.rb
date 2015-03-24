class Migration
  require 'open-uri'

  def migrate
  end

  #protected


  def external_connection
    Migration::DataSource.connection
  end

  def migrate_with_log
    puts "Started #{self.class.name}"
    migrate
    puts "Finished #{self.class.name}"
  end


  private

  class DataSource < ActiveRecord::Base
    self.abstract_class = true

    self.establish_connection(YAML.load(File.open(File.join(Rails.root, 'config', 'ethnicchic_old_db.yml')))[Rails.env]['ethnicchic'])
  end


end