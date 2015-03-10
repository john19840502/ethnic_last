class CalculatorPreferencesMigration
  def migrate

    Spree::Preference.all.each do |p|
      if p.key =~ /spree\/calculator.*/
        arr = p.key.split('/')
        id = arr[-1]
        key = arr[-2]

        calc = nil
        begin
          calc = Spree::Calculator.find(id)
          calc.set_preference(key, p.value)
          calc.save!
        rescue ActiveRecord::SubclassNotFound, NoMethodError
        end
      end
    end

  end
end
