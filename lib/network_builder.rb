require "network"

class NetworkBuilder
  def self.build(layer_sizes)
    raise "Network must have at least 2 layers" unless layer_sizes.size >= 2

    layers = []
    layer_sizes.each do |count|
      layer = []
      count.times{ layer << Neuron.new() }
      layer.each{|n1| layers.last.each{|n2| n1.add_input_neuron(n2)}} unless layers.empty?
#      puts "Add layer with #{layer.size} neurons"
      layers << layer
    end

    Network.new(layers.last)
  end
end