require_relative "../repository"
require_relative "../models/rental"

class RentalRepository < Repository

  self.model = Rental

  protected

  def load_instance_relations(instance, cars:)
    instance.car = cars.fetch(instance.car_id)
  end

end
