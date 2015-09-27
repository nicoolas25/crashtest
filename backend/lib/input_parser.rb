require_relative "repositories/car_repository"
require_relative "repositories/rental_repository"

class InputParser
  def initialize(filepath)
    @filepath = filepath
  end

  def cars
    @cars ||= CarRepository.new.tap do |repository|
      car_hashes = input_hash.fetch("cars")
      repository.load(car_hashes)
    end
  end

  def rentals
    @rentals ||= RentalRepository.new.tap do |repository|
      rental_hashes = input_hash.fetch("rentals")
      repository.load(rental_hashes, cars: cars)
    end
  end

  private

  def input_hash
    @inputh_hash ||= JSON.parse(content)
  end

  def content
    File.read(@filepath)
  end
end
