require "json"

require_relative "../lib/input_parser"

filepath = ARGV[0]
raise "No filepath was given to the script" if filepath.nil?
raise "File #{filepath} doesn't exists" if !File.exists?(filepath)

modification_repository = InputParser.new(filepath).modifications

modifications = modification_repository.all.map do |modification|
  {
    id: modification.id,
    rental_id: modification.rental_id,
    actions: modification.actions.map do |action|
      {
        who: action.actor,
        type: action.type,
        amount: action.amount,
      }
    end
  }
end

output = JSON.pretty_generate({ rental_modifications: modifications })
puts output
