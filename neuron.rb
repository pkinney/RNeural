class Neuron
  TRANSFER_FUNCTIONS = {
      :sigmoid => Proc.new{|value| (1.0+Math.tanh(value))/2.0},
      :step => Proc.new{|value| value>=0.5 ? 1.0 : 0.0},
      :linear_step => Proc.new{|value| [[value, 1.0].min, 0.0].max},
      :linear => Proc.new{|value| value}
  }
  
  def initialize(inputs = [])
    @inputs = inputs
    @weights = {}
    @transfer = TRANSFER_FUNCTIONS[:sigmoid]
    inputs.each{|i| @weights[i] = random_weight}
  end

  def input(inp)
    raise "Cannot input values to non-input neurons" unless input_neuron?
    @input_value = inp
  end

  def output
    if input_neuron?
      raise "Cannot get output of input neuron that has not had its value set" unless @input_value
      @input_value
    else
      transfer_function(@inputs.collect{|i| i.output * @weights[i]}.inject(:+) + (@bias || 0))
    end
  end

  def input_neuron?
    @inputs.empty?
  end

  def add_input_neuron(n, weight=nil)
    unless @inputs.include?(n)
      @inputs << n
      @weights[n] = weight || random_weight
    end
  end

  def set_weight(n, weight)
    @weights[n] = weight if @inputs.include?(n)
  end

  def set_bias(b)
    @bias = b
  end

  def set_transfer_function(func=nil, &block)
    if func.is_a? Symbol
      raise "Unknown transfer function: #{func}. Use one of [#{TRANSFER_FUNCTIONS.keys.join(", ")}]" unless TRANSFER_FUNCTIONS.keys.include? func
      @transfer = TRANSFER_FUNCTIONS[func]
    elsif func.is_a? Proc
      @transfer = func
    elsif block
      @transfer = block
    end
  end

  def input_neurons
    @inputs
  end

private
  def random_weight
    rand
  end

  def transfer_function(value)
    (@transfer || TRANSFER_FUNCTIONS[:sigmoid]).call(value)
  end
end