require_relative "../repository"
require_relative "../models/car"

class CarRepository < Repository

  self.model = Car

end
