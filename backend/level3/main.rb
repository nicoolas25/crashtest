require "json"

require_relative "../lib/input_parser"

filepath = ARGV[0]
raise "No filepath was given to the script" if filepath.nil?
raise "File #{filepath} doesn't exists" if !File.exists?(filepath)

rental_repository = InputParser.new(filepath).rentals

rentrals = rental_repository.all.map do |rental|
  {
    id: rental.id,
    price: rental.price,
    commission: {
      insurance_fee: rental.insurance_fee.to_i,
      assistance_fee: rental.assistance_fee.to_i,
      drivy_fee: rental.drivy_fee.to_i,
    }
  }
end

output = JSON.pretty_generate({ rentals: rentrals })
puts output
