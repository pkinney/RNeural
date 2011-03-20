require "rspec"

describe "Network" do
  before(:each) {
    @pass_through_in = Neuron.new()
    @pass_through_out = Neuron.new([@pass_through_in])
    @pass_through_out.set_weight(@pass_through_in,1)
    @pass_through_out.set_bias(0)

    @all_neurons = []
    @all_neurons << @input1 = Neuron.new()
    @all_neurons << @input2 = Neuron.new()
    @all_neurons << @hidden1 = Neuron.new()
    @all_neurons << @hidden2 = Neuron.new()
    @all_neurons << @hidden3 = Neuron.new()
    @all_neurons << @output = Neuron.new()

    @hidden1.add_input_neuron(@input1)
    @hidden1.add_input_neuron(@input2)
    @hidden2.add_input_neuron(@input1)
    @hidden2.add_input_neuron(@input2)
    @hidden3.add_input_neuron(@input1)
    @hidden3.add_input_neuron(@input2)

    @output.add_input_neuron(@hidden1)
    @output.add_input_neuron(@hidden2)
    @output.add_input_neuron(@hidden3)
  }

  it "should be constructed from a single output neuron" do
    net = Network.new(@pass_through_out)
    net.built?.should == true
    net.total_neurons.should == 2

    net = Network.new(@output)
    net.built?.should == true
    net.total_neurons.should == 6
  end

  it "should know how many input neurons it has" do
    Network.new(@pass_through_out).num_input_neurons.should == 1
    Network.new(@output).num_input_neurons.should == 2
  end

  it "should know how many output neurons it has" do
    Network.new(@pass_through_out).num_output_neurons.should == 1
    Network.new(@output).num_output_neurons.should == 1
  end

  it "should know how many hidden neurons it has" do
    Network.new(@pass_through_out).num_hidden_neurons.should == 0
    Network.new(@output).num_hidden_neurons.should == 3
  end
end