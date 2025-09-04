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
  95  => '0.0186 * Math.exp(4.4267 * x)',
  96  => '0.025  * Math.exp(4.1624 * x)',
  97  => '0.0496 * Math.exp(3.5699 * x)',
  98  => '0.0688 * Math.exp(3.295  * x)',
  99  => '0.0597 * Math.exp(3.4625 * x)',
  100 => '0.0492 * Math.exp(3.6776 * x)',
  101 => '0.0525 * Math.exp(3.6776 * x)',
  102 => '0.0562 * Math.exp(3.6776 * x)',
  103 => '0.0616 * Math.exp(3.6313 * x)',
  104 => '0.0619 * Math.exp(3.6776 * x)',
  105 => '0.06544 * Math.exp(3.5716 * x)',
  106 => '0.0664 * Math.exp(3.6776 * x)',
  107 => '0.06691 * Math.exp(3.5716 * x)',
  108 => '0.0692 * Math.exp(3.577  * x)',
  109 => '0.0688 * Math.exp(3.5928 * x)',
  110 => '0.0703 * Math.exp(3.577  * x)'
}

created = 0
updated = 0
(95..110).each do |threshold|
  eq = equations[threshold]
  next unless eq

  pr = ProfitReference.find_or_initialize_by(period: period, since_percentage_profit: threshold)
  pr.equation = eq
  if pr.new_record?
    pr.save!
    created += 1
  else
    if pr.changed?
      pr.save!
      updated += 1
    else
      # ensure saved if not persisted for any reason
      pr.save! unless pr.persisted?
    end
  end

  # Attach required PositionTypes to this ProfitReference
  ["Profesionales", "Subdirectores", "Técnicos y Asistenciales"].each do |pt_name|
    pt = company.position_types.find_by(name: pt_name)
    unless pt
      puts "[profit_reference.seeds] PositionType '#{pt_name}' not found for company '#{company.name}', skipping for ProfitReference ##{pr.id}."
      next
    end
    ProfitReferenceHasPositionType.find_or_create_by!(profit_reference_id: pr.id, position_type_id: pt.id)
  end
end

puts "[profit_reference.seeds] Done. Created: #{created}, Updated: #{updated}."
