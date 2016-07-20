require_relative "../repository"
require_relative "../models/modification"

class ModificationRepository < Repository

  self.model = Modification

  protected

  def load_instance_relations(instance, rentals:)
    instance.rental = rentals.fetch(instance.rental_id)
  end

  # The `Modification` can have `nil` value for some of their fields.
  # It happens if you only modify the `start_date` but not the `end_date`
  # nor the `distance`.
  def attributes_for(hash)
    Modification.members.map do |name|
      hash.fetch(name.to_s, nil)
    end
  end

end
