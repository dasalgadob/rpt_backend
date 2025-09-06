# Seed ProfitReference for company "Fondo Nacional del Ahorro" and period "2025"
# Usage:
#  rails runner db/seeds/profit_reference.seeds.rb
# or require this file from db/seeds.rb

company = Company.where('LOWER(name) = ?', 'fondo nacional de garantias').first
if company.nil?
  puts '[profit_reference.seeds] Company "Fondo Nacional de Garantias" not found.'
  return
end

period = company.periods.find_by(name: '2025')
if period.nil?
  puts '[profit_reference.seeds] Period "2025" not found for company.'
  return
end

equations = {
  95  => '-35.641 * x * x + 82.392 * x - 44.524',
  96  => '-37.528 * x * x + 86.754 * x - 46.881',
  97  => '-39.561 * x * x + 91.455 * x - 49.421',
  98  => '-42.344 * x * x + 97.889 * x - 52.898',
  99  => '-44.98 * x * x + 103.98 * x - 56.19',
  100 => '0.4904 * x * x + 8.6967 * x - 6.1051',
  101 => '-40.319 * x * x + 94.534 * x - 51.001',
  102 => '-37.799 * x * x + 91.941 * x - 50.679',
  103 => '-38.305 * x * x + 93.703 * x - 51.784',
  104 => '-38.357 * x * x + 93.9 * x - 51.818',
  105 => '-39.345 * x * x + 96.303 * x - 53.123',
  106 => '-36.386 * x * x + 92.829 * x - 52.444',
  107 => '-37.711 * x * x + 96.352 * x - 54.629',
  108 => '-42.48 * x * x + 106.54 * x - 59.9',
  109 => '-43.748 * x * x + 109.51 * x - 61.37',
  110 => '-48.584 * x * x + 119.16 * x - 66.202'
}

created = 0
(95..110).each do |threshold|
  eq = equations[threshold]
  next unless eq

  # Always create a new ProfitReference record (no existence checks)
  pr = ProfitReference.create!(period: period, since_percentage_profit: threshold, equation: eq)
  created += 1

  # Attach required PositionTypes to this ProfitReference (only for newly created records)
  ["Directores", "Vicepresidentes"].each do |pt_name|
    pt = company.position_types.find_by(name: pt_name)
    unless pt
      puts "[profit_reference.seeds] PositionType '#{pt_name}' not found for company '#{company.name}', skipping for ProfitReference ##{pr.id}."
      next
    end
    ProfitReferenceHasPositionType.find_or_create_by!(profit_reference_id: pr.id, position_type_id: pt.id)
  end
end

puts "[profit_reference.seeds] Done. Created: #{created}."
