module VerilogFSM
  VERSION = "0.1.0"
end

%w[dot options state errors machine transition executable builder state_attribute_interceptor].each do |item|
  require File.join(File.dirname(__FILE__), 'verilog_fsm', item)
end



module VerilogFSM
  module ClassMethods
    def define_fsm(&block)
      raise 'FSM is already defined. Call define_fsm only once' if Machine[self]
      builder = Builder.new(self)
      Machine[self] = builder.process(&block)
      
      # TODO: check if all states are reachable
      # TODO: other checks? islands?
      
      # create alias for state attribute method to intercept it 
      VerilogFSM::StateAttributeInterceptor.add_interceptor(self)
    end
    
    def fsm_draw_graph(options = {})
      raise 'No FSM defined. Call define_fsm first' unless Machine[self]
      Machine[self].draw_graph(options)
    end
    
  end
  
  module InstanceMethods
    #
    # Which states are reachable from the current state
    def fsm_next_state_names
      Machine[self.class].reachable_states(self).map() {|item| item.name}
    end
    
    def fsm_next_states
      Machine[self.class].reachable_states(self)
    end
    
    def fsm_state_names
      Machine[self.class].states.map() {|item| item.name}
    end
    
    def fsm_states
      Machine[self.class].states
    end
    
    #
    # What are the next transitions
    def fsm_next_transition_names
      Machine[self.class].available_transitions(self).map() {|item| item.name}
    end
    
    def fsm_transition_names
      Machine[self.class].transitions.map() {|item| item.name}
    end

    ## Helper for designing API
    ## Expose underlying FSM
    def machine
      Machine[self.class]
    end
  
    ## TODO Find better way to add this feature
    ## Allows condition to be stored as string for template, and executed as ruby code.
    def evaluate_string(command)
      eval(command)
    end

  end
  
  def self.included(receiver)
    receiver.class_eval do 
      extend(ClassMethods)
      include(InstanceMethods)
    end
  end  
  
end
