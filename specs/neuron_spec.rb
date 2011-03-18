require "rspec"
require "neuron"

describe "A Neuron" do
  TEST_VALUES = [1.4, 2.7, 0.35, 0.1, 0, -5, 10000, -10000, 0.000001, 0.999999, 1.0000001]
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

  it "should build a neuron with the passed input neurons" do
    h = Neuron.new([@input1, @input2])

    h.input_neurons.should include(@input1)
    h.input_neurons.should include(@input2)
  end

  it "should be an input neuron if it has not input neurons connected to it" do
    @input1.input_neuron?.should == true
  end

  it "should be a hidden neuron if it has neurons connected to it as an input" do
    @hidden1.input_neuron?.should == false
  end

  it "should accept numerical input only if it is an input neuron" do
    expect {@input1.input(0.5)}.not_to raise_error
    expect {@hidden1.input(0.5)}.to raise_error
  end

  it "should raise an error if the transfer function is not valid" do
    expect{@input1.set_transfer_function(:linear)}.not_to raise_error
    expect{@input1.set_transfer_function(:bad_function)}.to raise_error
  end

  it "should get output from a single input-output pair" do
    @pass_through_out.set_transfer_function(:linear)
    TEST_VALUES.each do |kv|
      @pass_through_in.input(kv)
      @pass_through_out.output.should == kv
    end
  end

  it "should get output from a single input-output pair with a step function that is either 1 or 0" do
    @pass_through_out.set_transfer_function(:step)
    TEST_VALUES.each do |kv|
      @pass_through_in.input(kv)
      if(kv>=0.5)
        @pass_through_out.output.should == 1
      else
        @pass_through_out.output.should == 0
      end
      [0, 1].should include(@pass_through_out.output)
    end
  end

  it "should get output from a single input neuron with a step function that is within [0, 1]" do
    @pass_through_out.set_transfer_function(:linear_step)
    TEST_VALUES.each do |kv|
      @pass_through_in.input(kv)
      @pass_through_out.output.should be >= 0
      @pass_through_out.output.should be <= 1
      if(kv>1)
        @pass_through_out.output.should == 1
      elsif(kv<0)
        @pass_through_out.output.should == 0
      else
        @pass_through_out.output.should == kv
      end
    end
  end

  it "should pass the values through from input to output through a hidden layer" do
    @all_neurons.each{|a| a.set_transfer_function(:linear)}

    @hidden1.set_weight(@input1, 0.1)
    @hidden2.set_weight(@input1, 0.2)
    @hidden3.set_weight(@input1, 0.3)
    @hidden1.set_weight(@input2, 0.4)
    @hidden2.set_weight(@input2, 1.5)
    @hidden3.set_weight(@input2, 0.6)
    @hidden1.set_bias(0)
    @hidden2.set_bias(0)
    @hidden3.set_bias(0)

    @output.set_weight(@hidden1, 0.3)
    @output.set_weight(@hidden2, 0.5)
    @output.set_weight(@hidden3, 0.2)
    @output.set_bias(0)

    @input1.input(0.5)
    @input2.input(1.2)

    h1_e = (0.5*0.1+1.2*0.4)
    h2_e = (0.5*0.2+1.2*1.5)
    h3_e = (0.5*0.3+1.2*0.6)

#    h1_e = (1.0+Math.tanh(h1_e))/2.0
#    h2_e = (1.0+Math.tanh(h2_e))/2.0
#    h3_e = (1.0+Math.tanh(h3_e))/2.0

    o = h1_e*0.3 + h2_e*0.5 + h3_e*0.2

    @output.output.should be_within(0.001).of(o)
  end

end