config = YAML.load(File.read("#{Rails.root}/config/algolia.yml"))

AlgoliaSearch.configuration = {
  application_id: config['app_id'],
  api_key: config['api_key'],
  pagination_backend: :kaminari
}
