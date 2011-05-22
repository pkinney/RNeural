module TrainingMatcher
  class TrainingSetMatcher
    def initialize(expected, iterations=250) 
      @set = expected
      @iterations = iterations
    end
    
    def matches?(target) 
      @trainer = target
      orig_error = @trainer.error_for_set(@set)
      @trainer.train_with_set(@set, @iterations*@set.size)
      new_error = @trainer.error_for_set(@set)
      
      # @trainer.print_status(@set)
      
      (new_error < orig_error) && (new_error < 0.1)
    end
    
    def failure_message_for_should 
      "expected network trainer to match training set"
    end
    
    def failure_message_for_should_not 
      "expected network trainer not to match training set"
    end
  end
  
  def train_to (expected, iterations=250)
    TrainingSetMatcher.new(expected, iterations)
  end
  
  def set_for(input_sets, &block)
    input_sets.collect {|input| {:in => input, :out => block.call(input)}}
  end
end