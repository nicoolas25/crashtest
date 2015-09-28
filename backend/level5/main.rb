require "json"

require_relative "../lib/input_parser"

filepath = ARGV[0]
raise "No filepath was given to the script" if filepath.nil?
raise "File #{filepath} doesn't exists" if !File.exists?(filepath)

rental_repository = InputParser.new(filepath).rentals

rentrals = rental_repository.all.map do |rental|
  {
    id: rental.id,
    actions: [
      {
        who: "driver",
        type: "debit",
        amount: rental.driver_debit,
      },
      {
        who: "owner",
        type: "credit",
        amount: rental.owner_credit,
      },
      {
        who: "insurance",
        type: "credit",
        amount: rental.insurance_credit,
      },
      {
        who: "assistance",
        type: "credit",
        amount: rental.assistance_credit,
      },
      {
        who: "drivy",
        type: "credit",
        amount: rental.drivy_credit,
      }
    ]
  }
end

output = JSON.pretty_generate({ rentals: rentrals })
puts output
