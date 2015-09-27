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
  }
end

output = JSON.pretty_generate({ rentals: rentrals })
puts output
