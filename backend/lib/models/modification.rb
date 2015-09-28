require_relative "action"
require_relative "../errors"

Modification = Struct.new(:id, :rental_id, :start_date, :end_date, :distance) do

  attr_accessor :rental

  def actions
    %w(driver owner insurance assistance drivy).map do |actor|
      actor_amount = "#{actor}_amount"
      previous_amount = rental.__send__(actor_amount)
      new_amount = updated_rental.__send__(actor_amount)
      Action.new(actor, previous_amount, new_amount)
    end
  end

  private

  def updated_rental
    @updated_rental ||= rental.dup.tap do |new_rental|
      new_rental.start_date = start_date || rental.start_date
      new_rental.end_date = end_date || rental.end_date
      new_rental.distance = distance || rental.distance
    end
  end

end
