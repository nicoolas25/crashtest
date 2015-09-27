NotFoundInRepository = Class.new(StandardError) do
  def initialize(repository, missing_id)
    @repository, @missing_id = repository, missing_id
  end

  def message
    "#{@repository} doesn't contain an element with: #{@missing_id} as id"
  end
end


DuplicateIdError = Class.new(StandardError) do
  def initialize(instance, other)
    @instance, @other = instance, other
  end

  def message
    "#{@instance} and #{@other} have the same id: #{@instance.id}"
  end
end

RentalDurationError = Class.new(StandardError) do
  def initialize(rental)
    @rental = rental
  end

  def message
    "Rental #%{id} has an invalid duration (from %{from} to %{to})" % {
      id: @rental.id,
      from: @rental.start_date,
      to: @rental.end_date,
    }
  end
end
