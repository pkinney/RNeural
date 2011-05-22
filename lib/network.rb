require "neuron"

class Network
  attr_reader :all_neurons
  attr_reader :input_neurons
  attr_reader :output_neurons
  
  def initialize(output_neurons = [], input_neurons = nil)
    @all_neurons = []
    @input_neurons = []
    @output_neurons = []
    @output_neurons << output_neurons
    @output_neurons.flatten!

    @output_neurons.each {|n| add_neuron_and_its_inputs(n)}

    if input_neurons
      raise "The input neuron list is not the exact inputs for the output neurons" unless input_neurons.size == @input_neurons.size && @input_neurons.all?{|n| input_neurons.include?(n)}
      @input_neurons = input_neurons
    end
  end

  def input(*values)
    raise "This network has not been built yet" unless built?
    raise "This network only accepts #{num_input_neurons} inputs, not #{values.flatten.size}" unless values.flatten.size == num_input_neurons
    
    for i in 0...num_input_neurons do
      @input_neurons[i].input(values.flatten[i])
    end

    @output_neurons.collect{|o| o.output}
  end

  def built?
    num_input_neurons > 0 && num_output_neurons > 0
  end

  def num_neurons
    @all_neurons.size
  end

  def num_input_neurons
    @input_neurons.size
  end

  def num_output_neurons
    @output_neurons.size
  end

  def num_hidden_neurons
    num_neurons - num_output_neurons - num_input_neurons
  end
  
  def num_connections
    sum = 0
    @all_neurons.each { |n| sum += n.input_neurons.size }
    sum
  end

  private
  
  def add_neuron_and_its_inputs(neuron)
    @all_neurons << neuron unless @all_neurons.include?(neuron)
    if neuron.input_neuron?
      @input_neurons << neuron unless @input_neurons.include?(neuron)
    else
      neuron.input_neurons.each{|n| add_neuron_and_its_inputs(n)}
    end
  end
end