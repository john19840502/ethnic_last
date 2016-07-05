object false
child(@rates => :rates) do
  attributes *[:name, :cost]
end
node(:count) { @rates.count }
node(:currency) { @currency }