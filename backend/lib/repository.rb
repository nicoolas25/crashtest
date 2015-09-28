require_relative "errors"

class Repository

  class << self
    attr_accessor :model
  end

  def initialize
    @instances = {}
  end

  def all
    @instances.values
  end

  def fetch(id)
    @instances.fetch(id)
  rescue KeyError
    raise NotFoundInRepository.new(self, id)
  end

  def load(hashes, dependencies = {})
    Array(hashes).each do |hash|
      attributes = attributes_for(hash)
      self.class.model.new(*attributes).tap do |instance|
        load_instance_relations(instance, **dependencies)
        register(instance)
      end
    end
  end

  protected

  def load_instance_relations(instance, **dependencies)
    # Does nothing by default, override it to load relations.
  end

  def attributes_for(hash)
    self.class.model.members.map do |name|
      hash.fetch(name.to_s)
    end
  end

  private

  def register(new_instance)
    if existing_instance = @instances[new_instance.id]
      raise DuplicateIdError.new(existing_instance, new_instance)
    else
      @instances[new_instance.id] = new_instance
    end
  end

end
