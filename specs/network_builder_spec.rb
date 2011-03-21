require "rspec"

require "neuron"
require "network_builder"

describe "Network Builder" do

  it "should build a pass-through network" do
    net = NetworkBuilder.build([1, 1])

    net.built?.should == true
    net.num_neurons.should == 2
    net.num_input_neurons.should == 1
    net.num_output_neurons.should == 1
    net.num_hidden_neurons.should == 0
  end

  it "should build a network with hidden neurons" do
    net = NetworkBuilder.build([2, 3, 1])

    net.built?.should == true
    net.num_neurons.should == 6
    net.num_input_neurons.should == 2
    net.num_output_neurons.should == 1
    net.num_hidden_neurons.should == 3
  end
end