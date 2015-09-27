require_relative "../repository"
require_relative "../models/car"

class CarRepository < Repository

  def load(hashes)
    Array(hashes).each do |hash|
      attributes = Car.members.map { |name| hash.fetch(name.to_s) }
      Car.new(*attributes).tap { |car| register(car) }
    end
  end

end
