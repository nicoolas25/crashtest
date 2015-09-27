require "support/level"

=begin
RSpec.describe "The level 1 script" do
  let(:level) { 1 }
  include_context "level's test"
end

RSpec.describe "The level 2 script" do
  let(:level) { 2 }
  include_context "level's test"
end

RSpec.describe "The level 3 script" do
  let(:level) { 3 }
  include_context "level's test"
end
=end

RSpec.describe "The level 4 script" do
  let(:level) { 4 }
  include_context "level's test"
end
