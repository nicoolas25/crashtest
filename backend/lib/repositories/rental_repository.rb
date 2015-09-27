require_relative "../repository"
require_relative "../models/rental"

class RentalRepository < Repository

  def load(hashes, dependencies)
    Array(hashes).each do |hash|
      attributes = Rental.members.map { |name| hash.fetch(name.to_s) }
      Rental.new(*attributes).tap do |rental|
        load_instance_relations(rental, **dependencies)
        register(rental)
      end
    end
  end

  private

  def load_instance_relations(instance, cars:)
    instance.car = cars.fetch(instance.car_id)
  end

end
