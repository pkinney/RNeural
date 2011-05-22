class Neuron
  TRANSFER_FUNCTIONS = {
      :sigmoid => Proc.new{|value| (1.0+Math.tanh(value))/2.0},
      :step => Proc.new{|value| value>=0.5 ? 1.0 : 0.0},
      :linear_step => Proc.new{|value| [[value, 1.0].min, 0.0].max},
      :linear => Proc.new{|value| value}
  }
  
  attr_reader :last_output
  attr_reader :last_pretransfer_output
  attr_reader :inputs
  alias :input_neurons :inputs
  
  attr_accessor :bias_weight
  attr_reader :bias
  
  def initialize(inputs = nil)
    @inputs = inputs || []
    @weights = {}
    @transfer = TRANSFER_FUNCTIONS[:sigmoid]
    @inputs.each{|i| @weights[i] = random_weight}
    @bias = -1
    @bias_weight = random_weight
  end

  def input(inp)
    raise "Cannot input values to non-input neurons" unless input_neuron?
    @input_value = inp
  end

  def output
    if input_neuron?
      raise "Cannot get output of input neuron that has not had its value set" unless @input_value
      @last_output = @last_pretransfer_output = @input_value
    else
      b = input_neuron? ? 0 : (@bias || -1) * (@bias_weight || 0)
      @last_pretransfer_output = @inputs.collect{|i| i.output * @weights[i]}.inject(:+) + b
      @last_output = transfer_function(@last_pretransfer_output)
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

  def weight_for(n)
    @weights[n]
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

  def transfer_function(value)
    (@transfer || TRANSFER_FUNCTIONS[:sigmoid]).call(value)
  end
  
  def der_transfer_function(value)
    (transfer_function(value) - transfer_function(value-0.0001))/0.0001
  end

private
  def random_weight
    rand
  end
end