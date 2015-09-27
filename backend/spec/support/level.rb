require "json"

# A level is a script file that takes a filepath as first argument and outputs
# a JSON file on its standard output. This context test that when we pass the
# 'levelX/data.json' to the 'levelX/main.rb' it outputs a JSON that match the
# one in 'levelX/output.json'.
RSpec.shared_context "level's test" do

  subject(:run_script) do
    io = IO.popen("bundle exec ruby #{dir}/main.rb #{dir}/data.json")
    JSON.parse(io.read)
  end

  it "outputs the expected JSON data" do
    is_expected.to eq expected_output
  end

  let(:expected_output) do
    expected_output_content = File.read("#{dir}/output.json")
    JSON.parse(expected_output_content)
  end

  let(:dir) { File.expand_path("../../../level#{level}", __FILE__) }

end
