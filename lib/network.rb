require "neuron"

class Network
  def initialize(output_neurons = [], input_neurons = nil)
    @all_neurons = []
    @inputs = []
    @outputs = []
    @outputs << output_neurons
    @outputs.flatten!

    @outputs.each {|n| add_neuron_and_its_inputs(n)}

    if input_neurons
      raise "The input neuron list is not the exact inputs for the output neurons" unless input_neurons.size == @inputs.size && @inputs.all?{|n| input_neurons.include?(n)}
      @inputs = input_neurons
    end
  end

  def input(*values)
    raise "This network has not been built yet" unless built?
    raise "This network only accepts #{num_input_neurons} inputs, not #{values.flatten.size}" unless values.flatten.size == num_input_neurons

    for i in 0...num_input_neurons do
      @inputs[i].input(values.flatten[i])
    end

    @outputs.collect{|o| o.output}
  end

  def built?
    num_input_neurons > 0 && num_output_neurons > 0
  end

  def num_neurons
    @all_neurons.size
  end

  def num_input_neurons
    @inputs.size
  end

  def num_output_neurons
    @outputs.size
  end

  def num_hidden_neurons
    @all_neurons.size - @outputs.size - @inputs.size
  end

  private
  def add_neuron_and_its_inputs(neuron)
    @all_neurons << neuron unless @all_neurons.include?(neuron)
    if neuron.input_neuron?
      @inputs << neuron unless @inputs.include?(neuron)
    else
      neuron.input_neurons.each{|n| add_neuron_and_its_inputs(n)}
    end
  end
end