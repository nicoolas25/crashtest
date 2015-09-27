require_relative "errors"

class Repository
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

  def load(*args)
    raise NotImplementedError
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
