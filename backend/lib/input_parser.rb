require_relative "repositories/car_repository"
require_relative "repositories/rental_repository"
require_relative "repositories/modification_repository"

class InputParser
  def initialize(filepath)
    @filepath = filepath
  end

  def rentals
    @rentals ||= RentalRepository.new.tap do |repository|
      rental_hashes = input_hash.fetch("rentals")
      repository.load(rental_hashes, cars: cars)
    end
  end

  def modifications
    @modifications ||= ModificationRepository.new.tap do |repository|
      modification_hashes = input_hash.fetch("rental_modifications")
      repository.load(modification_hashes, rentals: rentals)
    end
  end

  private

  def cars
    @cars ||= CarRepository.new.tap do |repository|
      car_hashes = input_hash.fetch("cars")
      repository.load(car_hashes)
    end
  end

  def input_hash
    @inputh_hash ||= JSON.parse(content)
  end

  def content
    File.read(@filepath)
  end
end
