class VariantPricesMigration < ::Migration
  def migrate
    connection = self.external_connection

    variants = connection.execute("select * from spree_variants;")


    arr = variants.each_slice(1000).to_a
    arr.each do |thousand_of_variants|
      ActiveRecord::Base.transaction do
        thousand_of_variants.each do |v|
          begin
            ActiveRecord::Base.no_touching do
              Spree::Price.create(
                  variant_id: v[0], # id
                  amount: v[2],     # price
                  currency: 'EUR'
              )
            end
          rescue Exception => ex
            Rails.logger.error "Can't create price: #{v.inspect}\n"
            Rails.logger.error ex.message
            Rails.logger.error ex.backtrace.join("\n")
          end
        end
      end
    end

  end
end