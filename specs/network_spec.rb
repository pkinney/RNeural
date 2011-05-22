require "rspec"
require "network"
require "network_builder"

describe "Network" do
  TEST_VALUES = [1.4, 2.7, 0.35, 0.1, 0, -5, 10000, -10000, 0.000001, 0.999999, 1.0000001]
  before(:each) {
    @pass_through_in = Neuron.new()
    @pass_through_out = Neuron.new([@pass_through_in])
    @pass_through_out.set_weight(@pass_through_in,1)
    @pass_through_out.bias_weight=0

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
    net.num_neurons.should == 2

    net = Network.new(@output)
    net.built?.should == true
    net.num_neurons.should == 6
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

  it "should get output from a single input-output pair" do
    @pass_through_out.set_transfer_function(:linear)
    TEST_VALUES.each do |kv|
      Network.new(@pass_through_out).input(kv)[0].should == kv
    end
  end

  it "should raise an exception if the inputs passed to it are not the correct size" do
    expect { Network.new(@output).input() }.to raise_error
    expect { Network.new(@output).input([]) }.to raise_error
    expect { Network.new(@output).input(0.3) }.to raise_error
    expect { Network.new(@output).input([0.3]) }.to raise_error
    expect { Network.new(@output).input([0.2, 0.5]) }.not_to raise_error
    expect { Network.new(@output).input([0.2, 0.5, 0.3]) }.to raise_error
    expect { Network.new(@output).input(nil) }.to raise_error

    expect { Network.new(@pass_through_out).input([]) }.to raise_error
    expect { Network.new(@pass_through_out).input(0.3) }.not_to raise_error
    expect { Network.new(@pass_through_out).input([0.3]) }.not_to raise_error
    expect { Network.new(@pass_through_out).input([0.2, 0.5]) }.to raise_error
    expect { Network.new(@pass_through_out).input([0.2, 0.5, 0.3]) }.to raise_error
    expect { Network.new(@pass_through_out).input(nil) }.to raise_error
  end

  it "should take a set of inputs and run it through the neurons" do
    @all_neurons.each{|a| a.set_transfer_function(:linear)}

    @hidden1.set_weight(@input1, 0.1)
    @hidden2.set_weight(@input1, 0.2)
    @hidden3.set_weight(@input1, 0.3)
    @hidden1.set_weight(@input2, 0.4)
    @hidden2.set_weight(@input2, 1.5)
    @hidden3.set_weight(@input2, 0.6)
    @hidden1.bias_weight = 0
    @hidden2.bias_weight = 0
    @hidden3.bias_weight = 0

    @output.set_weight(@hidden1, 0.3)
    @output.set_weight(@hidden2, 0.5)
    @output.set_weight(@hidden3, 0.2)
    @output.bias_weight = 0

    h1_e = (0.5*0.1+0.5*0.4)
    h2_e = (0.5*0.2+0.5*1.5)
    h3_e = (0.5*0.3+0.5*0.6)

    o = h1_e*0.3 + h2_e*0.5 + h3_e*0.2

    Network.new(@output).input(0.5, 0.5)[0].should be_within(0.00001).of(o)
  end

  it "should take a set of inputs and maintain the order of input neurons" do
    @all_neurons.each{|a| a.set_transfer_function(:linear)}

    @hidden1.set_weight(@input1, 0.1)
    @hidden2.set_weight(@input1, 0.2)
    @hidden3.set_weight(@input1, 0.3)
    @hidden1.set_weight(@input2, 0.4)
    @hidden2.set_weight(@input2, 1.5)
    @hidden3.set_weight(@input2, 0.6)
    @hidden1.bias_weight = 0
    @hidden2.bias_weight = 0
    @hidden3.bias_weight = 0

    @output.set_weight(@hidden1, 0.3)
    @output.set_weight(@hidden2, 0.5)
    @output.set_weight(@hidden3, 0.2)
    @output.bias_weight = 0

    h1_e = (0.5*0.1+1.2*0.4)
    h2_e = (0.5*0.2+1.2*1.5)
    h3_e = (0.5*0.3+1.2*0.6)

    o = h1_e*0.3 + h2_e*0.5 + h3_e*0.2

    Network.new(@output, [@input2, @input1]).input(1.2, 0.5)[0].should be_within(0.00001).of(o)
    Network.new(@output, [@input1, @input2]).input(0.5, 1.2)[0].should be_within(0.00001).of(o)
  end
end