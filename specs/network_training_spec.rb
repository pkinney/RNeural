require "rspec"
require "network"
require "network_builder"
require "network_trainer"
require File.dirname(__FILE__) + "/spec_helper"

describe "Network Learning" do
  include TrainingMatcher
  let(:two_bit_input_set) {[[0, 0], [1, 0], [0, 1], [1, 1]]}
  
  describe "Two-input perceptron" do
    subject { NetworkTrainer.new(NetworkBuilder.build([2, 1]), 1)}
    
    it { should train_to(set_for(two_bit_input_set) {|a| [a[0] && a[1]]}) }
    it { should train_to(set_for(two_bit_input_set) {|a| [a[0] || a[1]]}) }
    it { should train_to(set_for(two_bit_input_set) {|a| a[0]==1 && a[1]==1 ? [0] : [1]}) }
    it { should train_to(set_for(two_bit_input_set) {|a| a[0]==1 || a[1]==1 ? [0] : [1]}) }
    it { should_not train_to(set_for(two_bit_input_set) {|a| [a[0] ^ a[1]]}) }
    it { should_not train_to(set_for(two_bit_input_set) {|a| (a[0]==1) ^ (a[1]==1) ? [0] : [1]}) }
  end
  
  describe "Two-input network with hidden layer" do
    subject { NetworkTrainer.new(NetworkBuilder.build([2, 3, 1]), 1)}
    
    it { should train_to(set_for(two_bit_input_set) {|a| [a[0] && a[1]]}) }
    it { should train_to(set_for(two_bit_input_set) {|a| [a[0] || a[1]]}) }
    it { should train_to(set_for(two_bit_input_set) {|a| a[0]==1 && a[1]==1 ? [0] : [1]}) }
    it { should train_to(set_for(two_bit_input_set) {|a| a[0]==1 || a[1]==1 ? [0] : [1]}) }
    it { should train_to(set_for(two_bit_input_set) {|a| [a[0] ^ a[1]]}, 1000) }
    it { should train_to(set_for(two_bit_input_set) {|a| (a[0]==1) ^ (a[1]==1) ? [0] : [1]}, 1000) }
  end
  
  describe "Two-input, Two-output network" do
    subject { NetworkTrainer.new(NetworkBuilder.build([2, 2]), 1)}
    
    it { should train_to(set_for(two_bit_input_set) {|a| [a[0] && a[1], a[0] || a[1]]}) }
    it { should_not train_to(set_for(two_bit_input_set) {|a| [a[0] ^ a[1], a[0] && a[1]]}) }
  end
  
  describe "Two-input, Two-output network with hidden layer" do
    subject { NetworkTrainer.new(NetworkBuilder.build([2, 3, 2]), 1)}
    
    it { should train_to(set_for(two_bit_input_set) {|a| [a[0] && a[1], a[0] || a[1]]}) }
    it { should train_to(set_for(two_bit_input_set) {|a| [a[0] ^ a[1], a[0] && a[1]]}) }
  end
  
  describe "Many-input, Many-output network" do
    subject { NetworkTrainer.new(NetworkBuilder.build([10, 10]), 1)}
    
    input_set = []
    
    10.times do
      line = []
      10.times {line << rand(2)}
      input_set << line
    end
    
    it { should train_to( set_for(input_set) { |a| a.collect { |i| i ^ 1 } }, 1000 ) }
  end
  
  
end