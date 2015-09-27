require "support/level"

=begin
RSpec.describe "The level 1 script" do
  let(:level) { 1 }
  include_context "level's test"
end
=end

RSpec.describe "The level 2 script" do
  let(:level) { 2 }
  include_context "level's test"
end
