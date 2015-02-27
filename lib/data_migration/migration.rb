class Migration
  require 'open-uri'

  def migrate
  end

  #protected


  def external_connection
    Migration::DataSource.connection
  end

  private

  class DataSource < ActiveRecord::Base
    self.abstract_class = true

    self.establish_connection(YAML.load(File.open(File.join(Rails.root, 'config', 'ethnicchic_old_db.yml')))[Rails.env]['ethnicchic'])
  end

end