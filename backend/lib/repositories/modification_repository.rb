require_relative "../repository"
require_relative "../models/modification"

class ModificationRepository < Repository

  self.model = Modification

  protected

  def load_instance_relations(instance, rentals:)
    instance.rental = rentals.fetch(instance.rental_id)
  end

  def attributes_for(hash)
    Modification.members.map do |name|
      hash.fetch(name.to_s, nil)
    end
  end

end
