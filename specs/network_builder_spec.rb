require "rspec"

require "neuron"
require "network_builder"

describe "Small Simple Network Builder" do
  subject {NetworkBuilder.build([1, 1])}

  its(:built?) {should == true}
  its(:num_neurons) {should == 2}
  its(:num_input_neurons) {should == 1}
  its(:num_output_neurons) {should == 1}
  its(:num_hidden_neurons) {should == 0}
  its(:num_connections) {should == 1}
end


describe "Small Hidden Neuron Network Builder" do
  subject {NetworkBuilder.build([2, 3, 1])}

  its(:built?) {should == true}
  its(:num_neurons) {should == 6}
  its(:num_input_neurons) {should == 2}
  its(:num_output_neurons) {should == 1}
  its(:num_hidden_neurons) {should == 3}
  its(:num_connections) {should == 9}
end


describe "Large Network Builder" do
  subject {NetworkBuilder.build([20, 300, 9])}

  its(:built?) {should == true}
  its(:num_neurons) {should == 329}
  its(:num_input_neurons) {should == 20}
  its(:num_output_neurons) {should == 9}
  its(:num_hidden_neurons) {should == 300}
  its(:num_connections) {should == 9*300 + 300*20}
end
