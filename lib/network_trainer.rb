require 'network'

class NetworkTrainer
  def initialize(network, alpha = 0.1)
    @network = network
    @alpha = alpha
  end
  
  def single_example(inputs, expected)
    actual = @network.input(inputs)
    delta = {}
    
    @network.output_neurons.each_index do |i| 
      n = @network.output_neurons[i]
      delta[n] = n.der_transfer_function(n.last_pretransfer_output) * (expected[i] - n.last_output)
    end
    
    layer = @network.output_neurons
    until layer.first.input_neuron? do
      layer.each do |n1|
        n1.inputs.each do |n2|
          delta[n2] ||= 0
          delta[n2] += n2.der_transfer_function(n2.last_pretransfer_output) * n1.weight_for(n2) * delta[n1]
          
          # puts "Weight: #{n1.weight_for(n2)} -> #{n1.weight_for(n2) + @alpha * n2.last_output * delta[n1]}"
          n1.set_weight(n2, n1.weight_for(n2) + @alpha * n2.last_output * delta[n1])
        end
        # update the bias
        n1.bias_weight = n1.bias_weight + @alpha * n1.bias * delta[n1]
      end
      
      layer = layer.first.inputs
    end
  end
  
  def train_with_set(set, iterations = 1)
    iterations.times do
      example = set[rand(set.size)]
      single_example(example[:in], example[:out])
    end
  end
  
  def error_for_example(inputs, expected)
    actual = @network.input(inputs)
    sum = 0
    actual.each_index{|i| sum += (expected[i]-actual[i])**2 }
    Math.sqrt(sum)
  end
  
  def error_for_set(set)
    sum = 0
    set.each do |example|
      actual = @network.input(example[:in])
      error = error_for_example(example[:in], example[:out])
      sum += error_for_example(example[:in], example[:out])**2
    end
    Math.sqrt(sum/set.size)
  end
  
  def print_status(set)
    set.each do |example|
      actual = @network.input(example[:in])
      error = error_for_example(example[:in], example[:out])
      puts "[#{example[:in].join(' ')}] => [#{actual.collect{|m| '%.3f' % m}.join(' ')}] (#{'%.3f' % error})"
    end
  end
end